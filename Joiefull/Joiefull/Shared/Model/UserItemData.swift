import Foundation
import SwiftData

@Model
final class UserItemData {
    @Attribute(.unique) var itemId: Int
    var isFavorite: Bool
    var rating: Int?
    var comment: String?
    
    init(itemId: Int, isFavorite: Bool = false, rating: Int? = nil, comment: String? = nil) {
        self.itemId = itemId
        self.isFavorite = isFavorite
        self.rating = rating
        self.comment = comment
    }
}
