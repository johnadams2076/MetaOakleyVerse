import Foundation

struct BackgroundEditResponse: Codable, Equatable {
    let requestId: String
    let status: String
    let mediaType: String?
    let promptUsed: String?
    let resultBase64: String?
    let resultURL: String?
    let provider: String?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case status
        case mediaType = "media_type"
        case promptUsed = "prompt_used"
        case resultBase64 = "result_base64"
        case resultURL = "result_url"
        case provider
        case message
    }
}
