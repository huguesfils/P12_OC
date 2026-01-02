import Foundation
import Combine
import FactoryKit

@MainActor
@Observable
public class HomeViewModel {
    private let service: ClothesServiceProtocol
    
    var items: [Item] = []
    var isLoading = false
    var errorMessage: String?
    
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
}
