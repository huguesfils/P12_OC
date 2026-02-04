import Foundation
@testable import Joiefull

final class MockUserItemDataService: UserItemDataServiceProtocol, @unchecked Sendable {
    // MARK: - Stub data
    var favorites: Set<Int> = []
    var ratings: [Int: Int] = [:]
    var comments: [Int: String] = [:]

    // MARK: - Error simulation
    var errorToThrow: Error?

    // MARK: - Protocol methods
    func toggleFavorite(itemId: Int) async throws {
        if let error = errorToThrow { throw error }
        if favorites.contains(itemId) {
            favorites.remove(itemId)
        } else {
            favorites.insert(itemId)
        }
    }

    func setRating(itemId: Int, rating: Int) async throws {
        if let error = errorToThrow { throw error }
        ratings[itemId] = rating
    }

    func setComment(itemId: Int, comment: String) async throws {
        if let error = errorToThrow { throw error }
        comments[itemId] = comment
    }

    func isFavorite(itemId: Int) async -> Bool {
        favorites.contains(itemId)
    }

    func getRating(itemId: Int) async -> Int? {
        ratings[itemId]
    }

    func getComment(itemId: Int) async -> String? {
        comments[itemId]
    }

    func getAllFavoriteIds() async -> [Int] {
        Array(favorites)
    }
}
