import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Articles", systemImage: "square.grid.2x2")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favoris", systemImage: "heart.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
