import Foundation
import FactoryKit

@MainActor
@Observable
public class HomeViewModel {
    private let service: ClothesServiceProtocol
    
    var items: [Item] = []
    var isLoading = false
    var errorMessage: String?
    var searchText: String = ""
    
    init(service: ClothesServiceProtocol = Container.shared.clothesService()) {
        self.service = service
    }
    
    func loadClothes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            items = try await service.fetchClothes()
        } catch {
            errorMessage = error.localizedDescription
            print("Erreur lors du chargement des vêtements: \(error)")
        }
        
        isLoading = false
    }
    
    var itemsByCategory: [String: [Item]] {
        Dictionary(grouping: items, by: { $0.category })
    }

    var sortedCategories: [String] {
        itemsByCategory.keys.sorted()
    }
    
    func formattedCategory(_ category: String) -> String {
        category.capitalized
    }
    
    var filteredCategories: [String] {
        if searchText.isEmpty {
            return sortedCategories
        } else {
            return sortedCategories.filter { category in
                let items = itemsByCategory[category] ?? []
                return items.contains { item in
                    matchesSearchText(item)
                }
            }
        }
    }
    
    func filteredItems(for category: String) -> [Item] {
        let items = itemsByCategory[category] ?? []
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
