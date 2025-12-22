import Foundation

protocol ClothesServiceProtocol {
    func fetchClothes() async throws -> [Item]
}

final class ClothesService: ClothesServiceProtocol {
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func fetchClothes() async throws -> [Item] {
        try await networkClient.request(ClothesAPI.clothes)
    }
}
