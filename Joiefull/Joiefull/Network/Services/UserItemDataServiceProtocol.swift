import Foundation
import SwiftData

// MARK: Interface
public protocol UserItemDataServiceProtocol: Sendable {
    func toggleFavorite(itemId: Int) async throws
    func setRating(itemId: Int, rating: Int) async throws
    func setComment(itemId: Int, comment: String) async throws
    func isFavorite(itemId: Int) async -> Bool
    func getRating(itemId: Int) async -> Int?
    func getComment(itemId: Int) async -> String?
    func getAllFavoriteIds() async -> [Int]
}

// MARK: Service
@MainActor
final class UserItemDataService: UserItemDataServiceProtocol {
    private let modelContainer: ModelContainer
    
    nonisolated init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    // MARK: - Private Helper
    
    private func getOrCreate(itemId: Int, context: ModelContext) throws -> UserItemData {
        let descriptor = FetchDescriptor<UserItemData>(
            predicate: #Predicate { $0.itemId == itemId }
        )
        
        if let existing = try context.fetch(descriptor).first {
            return existing
        }
        
        let newData = UserItemData(itemId: itemId)
        context.insert(newData)
        return newData
    }
    
    // MARK: Methods
    
    func toggleFavorite(itemId: Int) async throws {
        let context = ModelContext(modelContainer)
        let userData = try getOrCreate(itemId: itemId, context: context)
        userData.isFavorite.toggle()
        try context.save()
    }
    
    func setRating(itemId: Int, rating: Int) async throws {
        let context = ModelContext(modelContainer)
        let userData = try getOrCreate(itemId: itemId, context: context)
        userData.rating = rating
        try context.save()
    }
    
    func setComment(itemId: Int, comment: String) async throws {
        let context = ModelContext(modelContainer)
        let userData = try getOrCreate(itemId: itemId, context: context)
        userData.comment = comment
        try context.save()
    }
    
    func isFavorite(itemId: Int) async -> Bool {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<UserItemData>(
            predicate: #Predicate { $0.itemId == itemId }
        )
        guard let userData = try? context.fetch(descriptor).first else {
            return false
        }
        return userData.isFavorite
    }
    
    func getRating(itemId: Int) async -> Int? {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<UserItemData>(
            predicate: #Predicate { $0.itemId == itemId }
        )
        guard let userData = try? context.fetch(descriptor).first else {
            return nil
        }
        return userData.rating
    }
    
    func getComment(itemId: Int) async -> String? {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<UserItemData>(
            predicate: #Predicate { $0.itemId == itemId }
        )
        guard let userData = try? context.fetch(descriptor).first else {
            return nil
        }
        return userData.comment
    }
    
    func getAllFavoriteIds() async -> [Int] {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<UserItemData>(
            predicate: #Predicate { $0.isFavorite == true }
        )
        let favorites = (try? context.fetch(descriptor)) ?? []
        return favorites.map { $0.itemId }
    }
}
