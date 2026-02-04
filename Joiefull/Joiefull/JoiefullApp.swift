import SwiftUI
import SwiftData
import FactoryKit

@main
struct JoiefullApp: App {
    let modelContainer: ModelContainer
        
    init() {
        do {
            let container = try ModelContainer(for: UserItemData.self, migrationPlan: UserItemDataMigrationPlan.self)
            modelContainer = container
            
            Container.shared.modelContainer.register {
                container
            }
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(modelContainer)
    }
}
