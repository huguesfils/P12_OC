import Foundation
import FactoryKit
import SwiftData

enum FilterMode: String, CaseIterable {
    case all = "Tous"
    case favorites = "Favoris"
}

@MainActor
@Observable
public class HomeViewModel {
    // MARK: Properties
    private let service: ClothesServiceProtocol
    let userItemDataService: UserItemDataServiceProtocol

    var items: [Item] = []
    var isLoading = false
    var errorMessage: String?
    var searchText: String = ""
    var filterMode: FilterMode = .all

    func displayedItems(favoriteIds: Set<Int>) -> [Item] {
        switch filterMode {
        case .all:
            return items
        case .favorites:
            return items.filter { favoriteIds.contains($0.id) }
        }
    }

    func itemsByCategory(favoriteIds: Set<Int>) -> [String: [Item]] {
        Dictionary(grouping: displayedItems(favoriteIds: favoriteIds), by: { $0.category })
    }

    func sortedCategories(favoriteIds: Set<Int>) -> [String] {
        itemsByCategory(favoriteIds: favoriteIds).keys.sorted()
    }

    init(
        service: ClothesServiceProtocol = Container.shared.clothesService(),
        userItemDataService: UserItemDataServiceProtocol = Container.shared.userItemDataService()
    ) {
        self.service = service
        self.userItemDataService = userItemDataService
    }

    // MARK: Methods
    func loadClothes() async {
        isLoading = true
        errorMessage = nil

        do {
            items = try await service.fetchClothes()
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func isFavorite(itemId: Int) async -> Bool {
        await userItemDataService.isFavorite(itemId: itemId)
    }

    func toggleFavorite(itemId: Int) async {
        do {
            try await userItemDataService.toggleFavorite(itemId: itemId)
        } catch {
            errorMessage = "Impossible de sauvegarder le favori"
        }
    }
    
    func shouldShowNoSearchResults(favoriteIds: Set<Int>) -> Bool {
        filteredCategories(favoriteIds: favoriteIds).isEmpty && !searchText.isEmpty
    }

    func shouldShowEmptyFavorites(favoriteIds: Set<Int>) -> Bool {
        filterMode == .favorites && favoriteIds.isEmpty
    }

    func formattedCategory(_ category: String) -> String {
        category.capitalized
    }

    func filteredCategories(favoriteIds: Set<Int>) -> [String] {
        if searchText.isEmpty {
            return sortedCategories(favoriteIds: favoriteIds)
        } else {
            return sortedCategories(favoriteIds: favoriteIds).filter { category in
                let items = itemsByCategory(favoriteIds: favoriteIds)[category] ?? []
                return items.contains { item in
                    matchesSearchText(item)
                }
            }
        }
    }

    func filteredItems(for category: String, favoriteIds: Set<Int>) -> [Item] {
        let items = itemsByCategory(favoriteIds: favoriteIds)[category] ?? []
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { matchesSearchText($0) }
        }
    }
    
    func matchesSearchText(_ item: Item) -> Bool {
        let searchLower = searchText.lowercased()
        return item.name.lowercased().contains(searchLower) ||
        item.picture.description.lowercased().contains(searchLower) == true ||
        item.category.lowercased().contains(searchLower)
    }
}
