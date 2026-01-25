import Foundation

public struct Picture: Codable, Hashable {
    public let url: String
    public let description: String
}

public struct Item: Identifiable, Codable, Hashable {
    public let id: Int
    public let picture: Picture
    public let name: String
    public let category: String
    public let likes: Int
    public let price: Double
    public let originalPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case id, picture, name, category, likes, price
        case originalPrice = "original_price"
    }
}
