import Foundation
import FactoryKit

extension Container {
    static func setupMocks(
        networkClient: NetworkClientProtocol? = nil,
        clothesService: ClothesServiceProtocol? = nil
    ) {
        if let networkClient = networkClient {
            shared.networkClient.register { networkClient }
        }
        if let clothesService = clothesService {
            shared.clothesService.register { clothesService }
        }
    }
    
    static func reset() {
        shared.networkClient.reset()
        shared.clothesService.reset()
    }
}

