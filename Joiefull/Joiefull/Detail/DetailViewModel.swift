import Foundation
import FactoryKit

@MainActor
@Observable
public class DetailViewModel {
    // MARK: Properties
    let userItemDataService: UserItemDataServiceProtocol
    
    var isFavorite: Bool = false
    var userRating: Int = 0
    var userComment: String = ""
    
    init(userItemDataService: UserItemDataServiceProtocol = Container.shared.userItemDataService()) {
        self.userItemDataService = userItemDataService
    }
    
    // MARK: Methods
    func loadUserData(for itemId: Int) async {
        isFavorite = await userItemDataService.isFavorite(itemId: itemId)
        userRating = await userItemDataService.getRating(itemId: itemId) ?? 0
        userComment = await userItemDataService.getComment(itemId: itemId) ?? ""
    }
    
    func toggleFavorite(itemId: Int) async {
        do {
            try await userItemDataService.toggleFavorite(itemId: itemId)
            isFavorite.toggle()
        } catch {
        }
    }
    
    func saveRating(itemId: Int, rating: Int) {
        userRating = rating
        Task {
            do {
                try await userItemDataService.setRating(itemId: itemId, rating: rating)
            } catch {
                print("Erreur save rating: \(error)")
            }
        }
    }
    
    func saveComment(itemId: Int) {
        Task {
            do {
                try await userItemDataService.setComment(itemId: itemId, comment: userComment)
            } catch {
                print("Erreur save comment: \(error)")
            }
        }
    }
}
