import UIKit
@testable import Joiefull

final class MockImageDownloadService: ImageDownloadServiceProtocol, @unchecked Sendable {
    // MARK: - Stub data
    var imageToReturn: UIImage?

    // MARK: - Error simulation
    var errorToThrow: Error?

    // MARK: - Protocol methods
    func downloadImage(from urlString: String) async throws -> UIImage {
        if let error = errorToThrow { throw error }
        guard let image = imageToReturn else {
            throw APIError.invalidResponse
        }
        return image
    }
}
