import Foundation

struct DescribePhotoResponse: Codable, Equatable {
    let requestId: String
    let shortDescription: String
    let detailedDescription: String
    let spokenResponse: String
    let safetyNotes: [String]
    let model: String
    let provider: String

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case shortDescription = "short_description"
        case detailedDescription = "detailed_description"
        case spokenResponse = "spoken_response"
        case safetyNotes = "safety_notes"
        case model
        case provider
    }
}
