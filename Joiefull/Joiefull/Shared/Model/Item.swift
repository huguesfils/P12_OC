import Foundation

struct ItemData: Identifiable {
    let id = UUID()
    let imageName: String
    let label: String
    let price: String
    let rating: String
    let oldPrice: String
    let initialLikeCount: Int
}
