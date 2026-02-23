import Testing
import Foundation
import UIKit
@testable import Joiefull

@MainActor
struct DetailViewModelTests {
    // MARK: Properties
    let mockService: MockUserItemDataService
    let mockImageService: MockImageDownloadService
    let viewModel: DetailViewModel

    // MARK: Init
    init() {
        let service = MockUserItemDataService()
        let imageService = MockImageDownloadService()
        mockService = service
        mockImageService = imageService
        viewModel = DetailViewModel(userItemDataService: service, imageDownloadService: imageService)
    }

    // MARK: - Toggle Favorite

    @Test("Toggle favorite succeeds and clears error")
    func toggleFavoriteSuccess() async {
        await viewModel.toggleFavorite(itemId: 1)

        #expect(viewModel.errorMessage == nil)
        #expect(mockService.favorites.contains(1))
    }

    @Test("Toggle favorite failure sets error message")
    func toggleFavoriteFailure() async {
        mockService.errorToThrow = NSError(domain: "test", code: 1)

        await viewModel.toggleFavorite(itemId: 1)

        #expect(viewModel.errorMessage == JoieFullError.saveFavorite.localizedDescription)
        #expect(!mockService.favorites.contains(1))
    }

    @Test("Toggle favorite clears previous error on success")
    func toggleFavoriteClearsPreviousError() async {
        // First call fails
        mockService.errorToThrow = NSError(domain: "test", code: 1)
        await viewModel.toggleFavorite(itemId: 1)
        #expect(viewModel.errorMessage != nil)

        // Second call succeeds
        mockService.errorToThrow = nil
        await viewModel.toggleFavorite(itemId: 1)
        #expect(viewModel.errorMessage == nil)
    }

    // MARK: - Save Rating

    @Test("Save valid rating succeeds")
    func saveRatingSuccess() async {
        await viewModel.saveRating(itemId: 1, rating: 4)

        #expect(viewModel.errorMessage == nil)
        #expect(mockService.ratings[1] == 4)
    }

    @Test("Save rating with invalid value sets error")
    func saveRatingInvalidValue() async {
        await viewModel.saveRating(itemId: 1, rating: 6)

        #expect(viewModel.errorMessage == JoieFullError.invalidRating(value: 6).localizedDescription)
        #expect(mockService.ratings[1] == nil)
    }

    @Test("Save rating with negative value sets error")
    func saveRatingNegativeValue() async {
        await viewModel.saveRating(itemId: 1, rating: -1)

        #expect(viewModel.errorMessage == JoieFullError.invalidRating(value: -1).localizedDescription)
        #expect(mockService.ratings[1] == nil)
    }

    @Test("Save rating boundary values are valid")
    func saveRatingBoundaryValues() async {
        await viewModel.saveRating(itemId: 1, rating: 0)
        #expect(viewModel.errorMessage == nil)
        #expect(mockService.ratings[1] == 0)

        await viewModel.saveRating(itemId: 2, rating: 5)
        #expect(viewModel.errorMessage == nil)
        #expect(mockService.ratings[2] == 5)
    }

    @Test("Save rating failure sets error message")
    func saveRatingFailure() async {
        mockService.errorToThrow = NSError(domain: "test", code: 1)

        await viewModel.saveRating(itemId: 1, rating: 3)

        #expect(viewModel.errorMessage == JoieFullError.saveRating.localizedDescription)
    }

    // MARK: - Set Comment

    @Test("Set comment succeeds")
    func setCommentSuccess() async {
        await viewModel.setComment(itemId: 1, comment: "Great item!")

        #expect(viewModel.errorMessage == nil)
        #expect(mockService.comments[1] == "Great item!")
    }

    @Test("Set comment failure sets error message")
    func setCommentFailure() async {
        mockService.errorToThrow = NSError(domain: "test", code: 1)

        await viewModel.setComment(itemId: 1, comment: "Test")

        #expect(viewModel.errorMessage == JoieFullError.saveComment.localizedDescription)
    }

    @Test("Set empty comment succeeds")
    func setEmptyComment() async {
        await viewModel.setComment(itemId: 1, comment: "")

        #expect(viewModel.errorMessage == nil)
        #expect(mockService.comments[1] == "")
    }

    // MARK: - Load Share Image

    @Test("Load share image succeeds")
    func loadShareImageSuccess() async {
        let testImage = UIImage(systemName: "star")!
        mockImageService.imageToReturn = testImage

        await viewModel.loadShareImage(from: "https://example.com/image.jpg")

        #expect(viewModel.shareImage != nil)
    }

    @Test("Load share image failure sets shareImage to nil")
    func loadShareImageFailure() async {
        mockImageService.errorToThrow = APIError.invalidURL

        await viewModel.loadShareImage(from: "invalid")

        #expect(viewModel.shareImage == nil)
    }

    @Test("Load share image with no image returns nil")
    func loadShareImageNoImage() async {
        mockImageService.imageToReturn = nil

        await viewModel.loadShareImage(from: "https://example.com/image.jpg")

        #expect(viewModel.shareImage == nil)
    }
}
