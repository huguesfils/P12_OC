import Foundation

enum ClothesAPI {
    private static let baseURL = "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/api"
    
    static var clothes: String {
        "\(baseURL)/clothes.json"
    }
}

