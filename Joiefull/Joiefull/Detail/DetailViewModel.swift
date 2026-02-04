import Foundation
import FactoryKit

@MainActor
@Observable
public class DetailViewModel {
    // MARK: Properties
    let userItemDataService: UserItemDataServiceProtocol
    var errorMessage: String?

    init(userItemDataService: UserItemDataServiceProtocol = Container.shared.userItemDataService()) {
        self.userItemDataService = userItemDataService
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
}
