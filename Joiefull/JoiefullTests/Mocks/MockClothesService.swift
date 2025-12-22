import Foundation

final class MockClothesService: ClothesServiceProtocol {
    var itemsToReturn: [Item] = []
    var errorToThrow: Error?
    
    func fetchClothes() async throws -> [Item] {
        if let error = errorToThrow {
            throw error
        }
        return itemsToReturn
    }
}

final class MockNetworkClient: NetworkClientProtocol {
    var responseToReturn: Any?
    var errorToThrow: Error?
    
    func request<T: Decodable>(_ endpoint: String) async throws -> T {
        if let error = errorToThrow {
            throw error
        }
        
        guard let response = responseToReturn as? T else {
            throw APIError.invalidResponse
        }
        
        return response
    }
}
