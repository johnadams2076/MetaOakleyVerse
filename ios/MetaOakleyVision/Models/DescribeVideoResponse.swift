import Foundation

struct DescribeVideoResponse: Codable, Equatable {
    struct Observation: Codable, Equatable {
        let timestampSeconds: Double
        let description: String

        enum CodingKeys: String, CodingKey {
            case timestampSeconds = "timestamp_seconds"
            case description
        }
    }

    let requestId: String
    let summary: String
    let spokenResponse: String
    let observations: [Observation]
    let model: String
    let provider: String
    let strategy: String

    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
        case summary
        case spokenResponse = "spoken_response"
        case observations
        case model
        case provider
        case strategy
    }
}
