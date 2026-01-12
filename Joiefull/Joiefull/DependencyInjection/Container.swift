import Foundation
import FactoryKit

extension Container {
    // MARK: - Network Layer
    var networkClient: Factory<NetworkClientProtocol> {
        self {
            NetworkClient(session: .shared)
        }
        .singleton
    }
    
    // MARK: - Services
    var clothesService: Factory<ClothesServiceProtocol> {
        self {
            ClothesService(networkClient: self.networkClient())
        }
        .singleton
    }
}
