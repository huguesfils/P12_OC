import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var selectedItem: Item?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @ViewBuilder
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                NavigationSplitView {
                    listContent
                } detail: {
                    DetailView(item: selectedItem)
                }
            } else {
                NavigationStack {
                    listContent
                        .navigationDestination(for: Item.self) { item in
                            DetailView(item: item)
                        }
                }
            }
        }
        .task {
            await viewModel.loadClothes()
        }
    }
    
    @ViewBuilder
    private var listContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Text("Erreur")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Button("Réessayer") {
                            Task {
                                await viewModel.loadClothes()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                } else {
                    ForEach(viewModel.sortedCategories, id: \.self) { category in
                        VStack(alignment: .leading, spacing: 16) {
                            Text(viewModel.formattedCategory(category))
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ForEach(viewModel.itemsByCategory[category] ?? []) { item in
                                        if horizontalSizeClass == .regular {
                                            Button {
                                                selectedItem = item
                                            } label: {
                                                ItemCardView(item: item)
                                            }
                                            .buttonStyle(.plain)
                                        } else {
                                            NavigationLink(value: item) {
                                                ItemCardView(item: item)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    HomeView()
}
