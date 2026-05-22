import Foundation

struct VideoFrameSampler {
    let fps: Double

    func sample(frames: [VideoFrame], maxFrames: Int) -> [VideoFrame] {
        Array(frames.prefix(maxFrames))
    }
}
