import SwiftUI

struct FavoritesView: View {
    @State private var favoriteItems: [Item] = []
    
    var body: some View {
        NavigationStack {
            Group {
                if favoriteItems.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(favoriteItems) { item in
                                NavigationLink(value: item) {
                                    ItemCardView(item: item)
                                }
                            }
                        }
                        .padding()
                    }
                    .navigationDestination(for: Item.self) { item in
                        DetailView(item: item)
                    }
                }
            }
            .navigationTitle("Favoris")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("Pas de favoris")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Ajoutez des articles à vos favoris pour les retrouver ici")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    FavoritesView()
}
