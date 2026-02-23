import UIKit

// MARK: Interface
protocol ImageDownloadServiceProtocol: Sendable {
    func downloadImage(from urlString: String) async throws -> UIImage
}

// MARK: Implementation
final class ImageDownloadService: ImageDownloadServiceProtocol {
    private let session: URLSession

    nonisolated init(session: URLSession = .shared) {
        self.session = session
    }

    func downloadImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        if let cached = ImageCache.shared.getImage(for: url) {
            return cached
        }

        let (data, _) = try await session.data(from: url)

        guard let image = UIImage(data: data) else {
            throw APIError.invalidResponse
        }

        ImageCache.shared.setImage(image, for: url)

        return image
    }
}
