import Foundation
import SwiftData

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
