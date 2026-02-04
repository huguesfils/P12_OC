import Testing
import Foundation
@testable import Joiefull

@MainActor
struct HomeViewModelTests {
    // MARK: Properties
    let mockClothesService: MockClothesService
    let mockUserDataService: MockUserItemDataService
    let viewModel: HomeViewModel

    // MARK: Test data
    static let sampleItems: [Item] = [
        Item(id: 1, picture: Picture(url: "https://img.com/1", description: "Red shirt"), name: "T-shirt rouge", category: "tops", likes: 10, price: 19.99, originalPrice: 29.99),
        Item(id: 2, picture: Picture(url: "https://img.com/2", description: "Blue jeans"), name: "Jean bleu", category: "bottoms", likes: 5, price: 49.99, originalPrice: 59.99),
        Item(id: 3, picture: Picture(url: "https://img.com/3", description: "Black jacket"), name: "Veste noire", category: "tops", likes: 20, price: 89.99, originalPrice: 99.99),
    ]

    // MARK: Init
    init() {
        let clothesService = MockClothesService()
        let userDataService = MockUserItemDataService()
        mockClothesService = clothesService
        mockUserDataService = userDataService
        viewModel = HomeViewModel(service: clothesService, userItemDataService: userDataService)
    }

    // MARK: - Load Clothes

    @Test("Load clothes succeeds and populates items")
    func loadClothesSuccess() async {
        mockClothesService.itemsToReturn = HomeViewModelTests.sampleItems

        await viewModel.loadClothes()

        #expect(viewModel.items.count == 3)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("Load clothes failure sets error message")
    func loadClothesFailure() async {
        mockClothesService.errorToThrow = APIError.invalidResponse

        await viewModel.loadClothes()

        #expect(viewModel.items.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage != nil)
    }

    @Test("Load clothes sets isLoading to false after completion")
    func loadClothesIsLoadingReset() async {
        mockClothesService.itemsToReturn = []

        await viewModel.loadClothes()

        #expect(viewModel.isLoading == false)
    }

    // MARK: - Toggle Favorite

    @Test("Toggle favorite succeeds without error")
    func toggleFavoriteSuccess() async {
        await viewModel.toggleFavorite(itemId: 1)

        #expect(viewModel.errorMessage == nil)
        #expect(mockUserDataService.favorites.contains(1))
    }

    @Test("Toggle favorite failure sets error message")
    func toggleFavoriteFailure() async {
        mockUserDataService.errorToThrow = NSError(domain: "test", code: 1)

        await viewModel.toggleFavorite(itemId: 1)

        #expect(viewModel.errorMessage != nil)
    }

    // MARK: - Is Favorite

    @Test("isFavorite returns true when item is favorite")
    func isFavoriteTrue() async {
        mockUserDataService.favorites = [1]

        let result = await viewModel.isFavorite(itemId: 1)
        #expect(result == true)
    }

    @Test("isFavorite returns false when item is not favorite")
    func isFavoriteFalse() async {
        let result = await viewModel.isFavorite(itemId: 999)
        #expect(result == false)
    }

    // MARK: - Filter Mode

    @Test("Displayed items returns all items in all mode")
    func displayedItemsAllMode() {
        viewModel.items = HomeViewModelTests.sampleItems
        viewModel.filterMode = .all

        let displayed = viewModel.displayedItems(favoriteIds: [])
        #expect(displayed.count == 3)
    }

    @Test("Displayed items returns only favorites in favorites mode")
    func displayedItemsFavoritesMode() {
        viewModel.items = HomeViewModelTests.sampleItems
        viewModel.filterMode = .favorites

        let favoriteIds: Set<Int> = [1, 3]
        let displayed = viewModel.displayedItems(favoriteIds: favoriteIds)

        #expect(displayed.count == 2)
        #expect(displayed.map(\.id).contains(1))
        #expect(displayed.map(\.id).contains(3))
    }

    @Test("Displayed items returns empty when no favorites in favorites mode")
    func displayedItemsNoFavorites() {
        viewModel.items = HomeViewModelTests.sampleItems
        viewModel.filterMode = .favorites

        let displayed = viewModel.displayedItems(favoriteIds: [])
        #expect(displayed.isEmpty)
    }

    // MARK: - Categories

    @Test("Sorted categories returns alphabetically sorted unique categories")
    func sortedCategories() {
        viewModel.items = HomeViewModelTests.sampleItems

        let categories = viewModel.sortedCategories(favoriteIds: [])
        #expect(categories == ["bottoms", "tops"])
    }

    @Test("Formatted category capitalizes correctly")
    func formattedCategory() {
        #expect(viewModel.formattedCategory("tops") == "Tops")
        #expect(viewModel.formattedCategory("bottoms") == "Bottoms")
    }

    // MARK: - Filtered Items

    @Test("Filtered items returns all items of category when search is empty")
    func filteredItemsNoSearch() {
        viewModel.items = HomeViewModelTests.sampleItems
        viewModel.searchText = ""

        let items = viewModel.filteredItems(for: "tops", favoriteIds: [])
        #expect(items.count == 2)
        #expect(items.map(\.id).contains(1))
        #expect(items.map(\.id).contains(3))
    }

    @Test("Filtered items returns empty for unknown category")
    func filteredItemsUnknownCategory() {
        viewModel.items = HomeViewModelTests.sampleItems
        viewModel.searchText = ""

        let items = viewModel.filteredItems(for: "unknown", favoriteIds: [])
        #expect(items.isEmpty)
    }

    // MARK: - Search

    @Test("Search filters items by name")
    func searchByName() {
        viewModel.items = HomeViewModelTests.sampleItems
        viewModel.searchText = "jean"

        let categories = viewModel.filteredCategories(favoriteIds: [])
        #expect(categories == ["bottoms"])

        let items = viewModel.filteredItems(for: "bottoms", favoriteIds: [])
        #expect(items.count == 1)
        #expect(items.first?.id == 2)
    }

    @Test("Search filters items by description")
    func searchByDescription() {
        viewModel.items = HomeViewModelTests.sampleItems
        viewModel.searchText = "black"

        let categories = viewModel.filteredCategories(favoriteIds: [])
        #expect(categories.contains("tops"))

        let items = viewModel.filteredItems(for: "tops", favoriteIds: [])
        #expect(items.count == 1)
        #expect(items.first?.id == 3)
    }

    @Test("Search filters items by category")
    func searchByCategory() {
        viewModel.items = HomeViewModelTests.sampleItems
        viewModel.searchText = "bottoms"

        let categories = viewModel.filteredCategories(favoriteIds: [])
        #expect(categories == ["bottoms"])
    }

    @Test("Search is case insensitive")
    func searchCaseInsensitive() {
        viewModel.items = HomeViewModelTests.sampleItems
        viewModel.searchText = "JEAN"

        let items = viewModel.filteredItems(for: "bottoms", favoriteIds: [])
        #expect(items.count == 1)
    }

    @Test("Empty search returns all items")
    func emptySearchReturnsAll() {
        viewModel.items = HomeViewModelTests.sampleItems
        viewModel.searchText = ""

        let categories = viewModel.filteredCategories(favoriteIds: [])
        #expect(categories.count == 2)
    }

    @Test("Search with no match returns empty")
    func searchNoMatch() {
        viewModel.items = HomeViewModelTests.sampleItems
        viewModel.searchText = "xxxxxx"

        let categories = viewModel.filteredCategories(favoriteIds: [])
        #expect(categories.isEmpty)
    }

    // MARK: - Empty States

    @Test("Should show no search results when search has no match")
    func shouldShowNoSearchResults() {
        viewModel.items = HomeViewModelTests.sampleItems
        viewModel.searchText = "xxxxxx"

        #expect(viewModel.shouldShowNoSearchResults(favoriteIds: []) == true)
    }

    @Test("Should not show no search results when search is empty")
    func shouldNotShowNoSearchResultsEmptySearch() {
        viewModel.items = HomeViewModelTests.sampleItems
        viewModel.searchText = ""

        #expect(viewModel.shouldShowNoSearchResults(favoriteIds: []) == false)
    }

    @Test("Should show empty favorites when in favorites mode with none")
    func shouldShowEmptyFavorites() {
        viewModel.filterMode = .favorites

        #expect(viewModel.shouldShowEmptyFavorites(favoriteIds: []) == true)
    }

    @Test("Should not show empty favorites in all mode")
    func shouldNotShowEmptyFavoritesInAllMode() {
        viewModel.filterMode = .all

        #expect(viewModel.shouldShowEmptyFavorites(favoriteIds: []) == false)
    }

    @Test("Should not show empty favorites when favorites exist")
    func shouldNotShowEmptyFavoritesWhenExists() {
        viewModel.filterMode = .favorites

        #expect(viewModel.shouldShowEmptyFavorites(favoriteIds: [1]) == false)
    }
}
