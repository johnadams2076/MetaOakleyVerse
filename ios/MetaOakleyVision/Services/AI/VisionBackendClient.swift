import Foundation

final class VisionBackendClient: VisionBackendClientProtocol {
    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func describePhoto(imageData: Data, question: String?) async throws -> DescribePhotoResponse {
        let request = try makeDescribePhotoRequest(imageData: imageData, question: question)
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw AppError.backendUnavailable
        }
        guard (200 ..< 300).contains(http.statusCode) else {
            throw AppError.aiProviderError("HTTP \(http.statusCode)")
        }

        do {
            return try JSONDecoder().decode(DescribePhotoResponse.self, from: data)
        } catch {
            throw AppError.invalidBackendResponse
        }
    }

    func describeVideo(frames: [Data], question: String?) async throws -> DescribeVideoResponse {
        _ = frames
        _ = question
        throw AppError.unsupportedFeature("Video Q&A is not implemented in MVP.")
    }

    func requestBackgroundEdit(media: CapturedMedia, prompt: String?) async throws -> BackgroundEditResponse {
        _ = media
        _ = prompt
        throw AppError.unsupportedFeature("Background editing is not implemented in MVP.")
    }

    func makeDescribePhotoRequest(imageData: Data, question: String?) throws -> URLRequest {
        let url = baseURL.appending(path: "/v1/describe/photo")
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.appendMultipartField(name: "question", value: question ?? "", boundary: boundary)
        body.appendMultipartFile(
            fieldName: "image",
            fileName: "capture.jpg",
            mimeType: "image/jpeg",
            fileData: imageData,
            boundary: boundary
        )
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        return request
    }
}

private extension Data {
    mutating func appendMultipartField(name: String, value: String, boundary: String) {
        append("--\(boundary)\r\n".data(using: .utf8)!)
        append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        append("\(value)\r\n".data(using: .utf8)!)
    }

    mutating func appendMultipartFile(
        fieldName: String,
        fileName: String,
        mimeType: String,
        fileData: Data,
        boundary: String
    ) {
        append("--\(boundary)\r\n".data(using: .utf8)!)
        append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        append(fileData)
        append("\r\n".data(using: .utf8)!)
    }
}
