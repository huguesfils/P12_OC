import UIKit
import FactoryKit

@MainActor
@Observable
public class DetailViewModel {
    // MARK: Properties
    let userItemDataService: UserItemDataServiceProtocol
    private let imageDownloadService: ImageDownloadServiceProtocol
    var errorMessage: String?
    var shareImage: UIImage?

    init(
        userItemDataService: UserItemDataServiceProtocol = Container.shared.userItemDataService(),
        imageDownloadService: ImageDownloadServiceProtocol = Container.shared.imageDownloadService()
    ) {
        self.userItemDataService = userItemDataService
        self.imageDownloadService = imageDownloadService
    }

    // MARK: Methods
    func toggleFavorite(itemId: Int) async {
        do {
            try await userItemDataService.toggleFavorite(itemId: itemId)
            errorMessage = nil
        } catch {
            AppLogger.error(error)
            errorMessage = JoieFullError.saveFavorite.localizedDescription
        }
    }

    func saveRating(itemId: Int, rating: Int) async {
        guard rating >= 0 && rating <= 5 else {
            let error = JoieFullError.invalidRating(value: rating)
            AppLogger.error(error)
            errorMessage = error.localizedDescription
            return
        }

        do {
            try await userItemDataService.setRating(itemId: itemId, rating: rating)
            errorMessage = nil
        } catch {
            AppLogger.error(error)
            errorMessage = JoieFullError.saveRating.localizedDescription
        }
    }

    func setComment(itemId: Int, comment: String) async {
        do {
            try await userItemDataService.setComment(itemId: itemId, comment: comment)
            errorMessage = nil
        } catch {
            AppLogger.error(error)
            errorMessage = JoieFullError.saveComment.localizedDescription
        }
    }

    func loadShareImage(from urlString: String) async {
        do {
            shareImage = try await imageDownloadService.downloadImage(from: urlString)
        } catch {
            AppLogger.error(error)
            shareImage = nil
        }
    }
}
