import Foundation
import FactoryKit
import SwiftData
import SwiftUI

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

struct DIContainer {
    
    let networkClient: NetworkClientProtocol
    let clothesService: ClothesServiceProtocol
    let userItemService: UserItemDataServiceProtocol
    let imageDownloadService: ImageDownloadServiceProtocol
    
    init(modelContainer: ModelContainer) {
        let networkClient = NetworkClient(session: .shared)
        self.networkClient = networkClient
        self.clothesService = ClothesService(networkClient: networkClient)
        self.imageDownloadService = ImageDownloadService(session: .shared)
        self.userItemService = UserItemDataService(modelContainer: modelContainer)
    }
}

// MARK: EnvironmentKey

private struct DIContainerKey: EnvironmentKey {
    static let defaultValue: DIContainer? = nil
}

extension EnvironmentValues {
    var diContainer: DIContainer? {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}
