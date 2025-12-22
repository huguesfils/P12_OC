import Foundation
import Combine
import FactoryKit

@MainActor
@Observable
public class HomeViewModel {
    
    var items: [Item] = []
    var isLoading = false
    var errorMessage: String?
    
    private let clothesService: ClothesServiceProtocol
    
    init(clothesService: ClothesServiceProtocol? = nil) {
        self.clothesService = clothesService ?? Container.shared.clothesService()
    }
    
    func loadClothes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            items = try await clothesService.fetchClothes()
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
}
