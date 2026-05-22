import Foundation

struct CapturedMedia: Identifiable, Equatable {
    enum MediaType: Equatable {
        case photo
        case video
    }

    let id: UUID
    let type: MediaType
    let jpegData: Data?
    let localFileURL: URL?
    let createdAt: Date
}
