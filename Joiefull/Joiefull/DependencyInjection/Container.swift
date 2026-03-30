import Foundation
import SwiftData
import SwiftUI

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
    static var defaultValue: DIContainer? = nil
//    static var defaultValue: DIContainer? {
//        fatalError("DIContainer not set in environment")
//    }
}

extension EnvironmentValues {
    var diContainer: DIContainer? {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}
