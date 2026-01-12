import Foundation

struct Picture: Codable, Hashable {
    let url: String
    let description: String
}

struct Item: Identifiable, Codable, Hashable {
    let id: Int
    let picture: Picture
    let name: String
    let category: String
    let likes: Int
    let price: Double
    let originalPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case id, picture, name, category, likes, price
        case originalPrice = "original_price"
    }
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
