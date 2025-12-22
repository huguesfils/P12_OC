import Foundation

struct Picture: Codable {
    let url: String
    let description: String
}

struct Item: Identifiable, Codable {
    let id: Int
    let picture: Picture
    let name: String
    let category: String
    let likes: Int
    let price: Double
    let original_price: Double
}


struct ItemData: Identifiable {
    let id = UUID()
    let imageName: String
    let label: String
    let price: String
    let rating: String
    let oldPrice: String
    let initialLikeCount: Int
    let category: String
}
