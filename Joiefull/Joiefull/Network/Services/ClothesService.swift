import Foundation

protocol ClothesServiceProtocol: Sendable {
    func fetchClothes() async throws -> [Item]
}

final class ClothesService: ClothesServiceProtocol {
    private let networkClient: NetworkClientProtocol
    
    nonisolated init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func fetchClothes() async throws -> [Item] {
        try await networkClient.request(ClothesAPI.clothes)
    }
}
