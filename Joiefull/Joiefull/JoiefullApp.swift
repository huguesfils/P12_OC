import SwiftUI
import SwiftData

@main
struct JoiefullApp: App {
    let modelContainer: ModelContainer
    let diContainer: DIContainer
        
    init() {
        do {
            let container = try ModelContainer(for: UserItemData.self, migrationPlan: UserItemDataMigrationPlan.self)
            modelContainer = container
            
            diContainer = DIContainer(modelContainer: container)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(container: diContainer)
                .environment(\.diContainer, diContainer)
        }
        .modelContainer(modelContainer)
    }
}
