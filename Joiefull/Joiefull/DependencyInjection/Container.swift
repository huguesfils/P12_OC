import Foundation
import FactoryKit
import SwiftData

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
    
    var imageDownloadService: Factory<ImageDownloadServiceProtocol> {
        self {
            ImageDownloadService(session: .shared)
        }
        .singleton
    }

    // MARK: - Storage
    var modelContainer: Factory<ModelContainer> {
        self {
            fatalError("ModelContainer must be registered from JoiefullApp")
        }
        .singleton
    }

    var userItemDataService: Factory<UserItemDataServiceProtocol> {
        self {
            UserItemDataService(modelContainer: self.modelContainer())
        }
        .singleton
    }
}
