import SwiftUI

struct HomeView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State private var viewModel = HomeViewModel()
    @State private var selectedItem: Item?
    
    @ViewBuilder
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                NavigationSplitView {
                    listContent
                } detail: {
                    DetailView(item: selectedItem)
                }
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
            } else {
                NavigationStack {
                    listContent
                        .navigationDestination(for: Item.self) { item in
                            DetailView(item: item)
                        }
                }
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
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
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("Erreur")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Button("Réessayer") {
                            Task {
                                await viewModel.loadClothes()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                } else if viewModel.filteredCategories.isEmpty && !viewModel.searchText.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 48))
                            .foregroundStyle(.secondary)
                        Text("Aucun résultat")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text("Aucun article ne correspond à \"\(viewModel.searchText)\"")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                } else {
                    ForEach(viewModel.filteredCategories, id: \.self) { category in
                        let items = viewModel.filteredItems(for: category)
                        if !items.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text(viewModel.formattedCategory(category))
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(items) { item in
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
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    HomeView()
}
