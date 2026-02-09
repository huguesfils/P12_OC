import Testing
import SwiftData
@testable import Joiefull

@MainActor
struct UserItemDataServiceTests {
    // MARK: Properties
    let modelContainer: ModelContainer
    let service: UserItemDataService

    // MARK: Init
    init() throws {
        let schema = Schema([UserItemData.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: schema, configurations: [configuration])
        service = UserItemDataService(modelContainer: modelContainer)
    }

    // MARK: Helper Methods
    private func clearData() throws {
        let context = ModelContext(modelContainer)
        try context.delete(model: UserItemData.self)
        try context.save()
    }

    // MARK: Toggle Favorite Tests

    @Test("Toggle favorite creates new entry with favorite true")
    func toggleFavoriteCreatesNewEntry() async throws {
        try clearData()

        let itemId = 1
        try await service.toggleFavorite(itemId: itemId)

        let isFavorite = await service.isFavorite(itemId: itemId)
        #expect(isFavorite == true)
    }

    @Test("Toggle favorite twice returns to false")
    func toggleFavoriteTwice() async throws {
        try clearData()

        let itemId = 2
        try await service.toggleFavorite(itemId: itemId)
        try await service.toggleFavorite(itemId: itemId)

        let isFavorite = await service.isFavorite(itemId: itemId)
        #expect(isFavorite == false)
    }

    @Test("Toggle favorite multiple times alternates correctly")
    func toggleFavoriteMultipleTimes() async throws {
        try clearData()

        let itemId = 3

        // First toggle: false -> true
        try await service.toggleFavorite(itemId: itemId)
        #expect(await service.isFavorite(itemId: itemId) == true)

        // Second toggle: true -> false
        try await service.toggleFavorite(itemId: itemId)
        #expect(await service.isFavorite(itemId: itemId) == false)

        // Third toggle: false -> true
        try await service.toggleFavorite(itemId: itemId)
        #expect(await service.isFavorite(itemId: itemId) == true)
    }

    // MARK: Set Rating Tests

    @Test("Set rating creates new entry with rating")
    func setRatingCreatesNewEntry() async throws {
        try clearData()

        let itemId = 10
        let rating = 4
        try await service.setRating(itemId: itemId, rating: rating)

        let savedRating = await service.getRating(itemId: itemId)
        #expect(savedRating == rating)
    }

    @Test("Set rating updates existing entry")
    func setRatingUpdatesExisting() async throws {
        try clearData()

        let itemId = 11
        try await service.setRating(itemId: itemId, rating: 3)
        try await service.setRating(itemId: itemId, rating: 5)

        let savedRating = await service.getRating(itemId: itemId)
        #expect(savedRating == 5)
    }

    @Test("Set rating with multiple different values")
    func setRatingMultipleValues() async throws {
        try clearData()

        let itemId = 12
        let ratings = [1, 2, 3, 4, 5]

        for rating in ratings {
            try await service.setRating(itemId: itemId, rating: rating)
            let savedRating = await service.getRating(itemId: itemId)
            #expect(savedRating == rating)
        }
    }

    @Test("Get rating returns nil for non-existent item")
    func getRatingNonExistent() async throws {
        try clearData()

        let rating = await service.getRating(itemId: 999)
        #expect(rating == nil)
    }

    // MARK: Set Comment Tests

    @Test("Set comment creates new entry with comment")
    func setCommentCreatesNewEntry() async throws {
        try clearData()

        let itemId = 20
        let comment = "Great item!"
        try await service.setComment(itemId: itemId, comment: comment)

        let savedComment = await service.getComment(itemId: itemId)
        #expect(savedComment == comment)
    }

    @Test("Set comment updates existing entry")
    func setCommentUpdatesExisting() async throws {
        try clearData()

        let itemId = 21
        try await service.setComment(itemId: itemId, comment: "First comment")
        try await service.setComment(itemId: itemId, comment: "Updated comment")

        let savedComment = await service.getComment(itemId: itemId)
        #expect(savedComment == "Updated comment")
    }

    @Test("Set empty comment deletes comment")
    func setEmptyComment() async throws {
        try clearData()

        let itemId = 22
        try await service.setComment(itemId: itemId, comment: "Initial comment")
        try await service.setComment(itemId: itemId, comment: "")

        let savedComment = await service.getComment(itemId: itemId)
        #expect(savedComment == "")
    }

    @Test("Get comment returns nil for non-existent item")
    func getCommentNonExistent() async throws {
        try clearData()

        let comment = await service.getComment(itemId: 999)
        #expect(comment == nil)
    }

    // MARK: isFavorite Tests

    @Test("isFavorite returns false for non-existent item")
    func isFavoriteNonExistent() async throws {
        try clearData()

        let isFavorite = await service.isFavorite(itemId: 999)
        #expect(isFavorite == false)
    }

    @Test("isFavorite returns false for item with favorite false")
    func isFavoriteReturnsFalse() async throws {
        try clearData()

        let itemId = 30
        try await service.toggleFavorite(itemId: itemId)
        try await service.toggleFavorite(itemId: itemId)

        let isFavorite = await service.isFavorite(itemId: itemId)
        #expect(isFavorite == false)
    }

    // MARK: getAllFavoriteIds Tests

    @Test("getAllFavoriteIds returns empty array when no favorites")
    func getAllFavoriteIdsEmpty() async throws {
        try clearData()

        let favoriteIds = await service.getAllFavoriteIds()
        #expect(favoriteIds.isEmpty)
    }

    @Test("getAllFavoriteIds returns single favorite")
    func getAllFavoriteIdsSingle() async throws {
        try clearData()

        let itemId = 40
        try await service.toggleFavorite(itemId: itemId)

        let favoriteIds = await service.getAllFavoriteIds()
        #expect(favoriteIds.count == 1)
        #expect(favoriteIds.contains(itemId))
    }

    @Test("getAllFavoriteIds returns multiple favorites")
    func getAllFavoriteIdsMultiple() async throws {
        try clearData()

        let itemIds = [41, 42, 43, 44, 45]
        for itemId in itemIds {
            try await service.toggleFavorite(itemId: itemId)
        }

        let favoriteIds = await service.getAllFavoriteIds()
        #expect(favoriteIds.count == itemIds.count)
        for itemId in itemIds {
            #expect(favoriteIds.contains(itemId))
        }
    }

    @Test("getAllFavoriteIds excludes toggled off favorites")
    func getAllFavoriteIdsExcludesToggledOff() async throws {
        try clearData()

        let itemIds = [50, 51, 52]
        for itemId in itemIds {
            try await service.toggleFavorite(itemId: itemId)
        }

        // Toggle off the second one
        try await service.toggleFavorite(itemId: 51)

        let favoriteIds = await service.getAllFavoriteIds()
        #expect(favoriteIds.count == 2)
        #expect(favoriteIds.contains(50))
        #expect(!favoriteIds.contains(51))
        #expect(favoriteIds.contains(52))
    }

    // MARK: Combined Operations Tests

    @Test("Set rating and comment on same item")
    func setRatingAndComment() async throws {
        try clearData()

        let itemId = 60
        let rating = 5
        let comment = "Perfect!"

        try await service.setRating(itemId: itemId, rating: rating)
        try await service.setComment(itemId: itemId, comment: comment)

        let savedRating = await service.getRating(itemId: itemId)
        let savedComment = await service.getComment(itemId: itemId)

        #expect(savedRating == rating)
        #expect(savedComment == comment)
    }

    @Test("Toggle favorite and set rating on same item")
    func toggleFavoriteAndSetRating() async throws {
        try clearData()

        let itemId = 61
        let rating = 4

        try await service.toggleFavorite(itemId: itemId)
        try await service.setRating(itemId: itemId, rating: rating)

        let isFavorite = await service.isFavorite(itemId: itemId)
        let savedRating = await service.getRating(itemId: itemId)

        #expect(isFavorite == true)
        #expect(savedRating == rating)
    }

    @Test("All operations on same item")
    func allOperationsOnSameItem() async throws {
        try clearData()

        let itemId = 62
        let rating = 5
        let comment = "Excellent piece!"

        try await service.toggleFavorite(itemId: itemId)
        try await service.setRating(itemId: itemId, rating: rating)
        try await service.setComment(itemId: itemId, comment: comment)

        let isFavorite = await service.isFavorite(itemId: itemId)
        let savedRating = await service.getRating(itemId: itemId)
        let savedComment = await service.getComment(itemId: itemId)

        #expect(isFavorite == true)
        #expect(savedRating == rating)
        #expect(savedComment == comment)
    }

    @Test("Multiple items with different states")
    func multipleItemsDifferentStates() async throws {
        try clearData()

        // Item 1: favorite + rating + comment
        try await service.toggleFavorite(itemId: 70)
        try await service.setRating(itemId: 70, rating: 5)
        try await service.setComment(itemId: 70, comment: "Amazing")

        // Item 2: only rating
        try await service.setRating(itemId: 71, rating: 3)

        // Item 3: only comment
        try await service.setComment(itemId: 72, comment: "Nice")

        // Item 4: only favorite
        try await service.toggleFavorite(itemId: 73)

        // Verify item 1
        #expect(await service.isFavorite(itemId: 70) == true)
        #expect(await service.getRating(itemId: 70) == 5)
        #expect(await service.getComment(itemId: 70) == "Amazing")

        // Verify item 2
        #expect(await service.isFavorite(itemId: 71) == false)
        #expect(await service.getRating(itemId: 71) == 3)
        #expect(await service.getComment(itemId: 71) == nil)

        // Verify item 3
        #expect(await service.isFavorite(itemId: 72) == false)
        #expect(await service.getRating(itemId: 72) == nil)
        #expect(await service.getComment(itemId: 72) == "Nice")

        // Verify item 4
        #expect(await service.isFavorite(itemId: 73) == true)
        #expect(await service.getRating(itemId: 73) == nil)
        #expect(await service.getComment(itemId: 73) == nil)

        // Verify favorites list
        let favoriteIds = await service.getAllFavoriteIds()
        #expect(favoriteIds.count == 2)
        #expect(favoriteIds.contains(70))
        #expect(favoriteIds.contains(73))
    }
}
