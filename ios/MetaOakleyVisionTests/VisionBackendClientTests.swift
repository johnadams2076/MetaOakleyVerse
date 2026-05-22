import XCTest
@testable import MetaOakleyVision

final class VisionBackendClientTests: XCTestCase {
    override class func setUp() {
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    override class func tearDown() {
        URLProtocol.unregisterClass(MockURLProtocol.self)
    }

    func testParsesDescribePhotoResponse() async throws {
        let json = """
        {
          "request_id": "req-1",
          "short_description": "Short.",
          "detailed_description": "Detailed.",
          "spoken_response": "Spoken.",
          "safety_notes": [],
          "model": "m",
          "provider": "mock"
        }
        """.data(using: .utf8)!
        let client = makeClient(status: 200, data: json)
        let response = try await client.describePhoto(imageData: Data([0x01, 0x02]), question: nil)
        XCTAssertEqual(response.requestId, "req-1")
        XCTAssertEqual(response.provider, "mock")
    }

    func testMapsNon200Response() async {
        let client = makeClient(status: 500, data: Data("{}".utf8))
        do {
            _ = try await client.describePhoto(imageData: Data([0x00]), question: nil)
            XCTFail("Expected error")
        } catch let error as AppError {
            if case .aiProviderError = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Unexpected app error")
            }
        } catch {
            XCTFail("Unexpected error")
        }
    }

    func testMapsInvalidJSON() async {
        let client = makeClient(status: 200, data: Data("not-json".utf8))
        do {
            _ = try await client.describePhoto(imageData: Data([0x00]), question: nil)
            XCTFail("Expected invalid response")
        } catch let error as AppError {
            XCTAssertEqual(error, .invalidBackendResponse)
        } catch {
            XCTFail("Unexpected error")
        }
    }

    func testBuildsMultipartRequestCorrectly() throws {
        let client = VisionBackendClient(baseURL: URL(string: "http://127.0.0.1:8787")!)
        let request = try client.makeDescribePhotoRequest(imageData: Data([0x01]), question: "What is this?")
        let contentType = request.value(forHTTPHeaderField: "Content-Type") ?? ""
        XCTAssertTrue(contentType.contains("multipart/form-data"))
        let body = String(data: request.httpBody ?? Data(), encoding: .utf8) ?? ""
        XCTAssertTrue(body.contains("name=\"question\""))
        XCTAssertTrue(body.contains("name=\"image\""))
    }

    private func makeClient(status: Int, data: Data) -> VisionBackendClient {
        MockURLProtocol.responseStatusCode = status
        MockURLProtocol.responseData = data

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        return VisionBackendClient(baseURL: URL(string: "http://localhost:8787")!, session: session)
    }
}

private final class MockURLProtocol: URLProtocol {
    static var responseStatusCode = 200
    static var responseData = Data()

    override class func canInit(with request: URLRequest) -> Bool {
        _ = request
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let url = request.url else { return }
        let response = HTTPURLResponse(url: url, statusCode: Self.responseStatusCode, httpVersion: nil, headerFields: nil)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Self.responseData)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
