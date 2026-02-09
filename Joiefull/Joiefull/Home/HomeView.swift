import SwiftUI
import SwiftData

struct HomeView: View {
    // MARK: Properties
    @State private var viewModel = HomeViewModel()
    @State private var selectedItem: Item?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Query(filter: #Predicate<UserItemData> { $0.isFavorite })
    private var favorites: [UserItemData]

    private var favoriteIds: Set<Int> {
        Set(favorites.map { $0.itemId })
    }

    private var isCompact: Bool {
        horizontalSizeClass != .regular
    }

    // MARK: Body
    var body: some View {
        Group {
            if isCompact {
                NavigationStack {
                    listContent
                        .navigationDestination(for: Item.self) { item in
                            DetailView(item: item, onDismiss: {})
                        }
                }
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
            } else {
                NavigationSplitView {
                    listContent
                } detail: {
                    DetailView(item: selectedItem, onDismiss: {})
                }
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .automatic))
            }
        }
        .task {
            await viewModel.loadClothes()
        }
    }

    // MARK: ListContent view
    @ViewBuilder
    private var listContent: some View {
        VStack(spacing: 0) {
            Picker("Filtre", selection: $viewModel.filterMode) {
                ForEach(FilterMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .accessibilityLabel("Chargement des articles")
                    } else if let errorMessage = viewModel.errorMessage {
                        errorView(errorMessage)
                    } else if viewModel.shouldShowNoSearchResults(favoriteIds: favoriteIds) {
                        noSearchResultsView
                    } else if viewModel.shouldShowEmptyFavorites(favoriteIds: favoriteIds) {
                        emptyFavoritesView
                    } else {
                        ForEach(viewModel.filteredCategories(favoriteIds: favoriteIds), id: \.self) { category in
                            let items = viewModel.filteredItems(for: category, favoriteIds: favoriteIds)
                            if !items.isEmpty {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text(viewModel.formattedCategory(category))
                                        .font(.title)
                                        .bold()
                                        .foregroundStyle(.primary)
                                        .padding(.horizontal)
                                        .accessibilityAddTraits(.isHeader)

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            ForEach(items) { item in
                                                itemCard(for: item)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    .accessibilityLabel("\(items.count) articles")
                                    .accessibilityHint("Balayez pour voir plus d'articles")
                                }
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .scrollDismissesKeyboard(.immediately)
        }
    }

    // MARK: Item card
    @ViewBuilder
    private func itemCard(for item: Item) -> some View {
        if isCompact {
            NavigationLink(value: item) {
                ItemCardView(item: item, userItemDataService: viewModel.userItemDataService)
            }
            .buttonStyle(.plain)
        } else {
            Button {
                selectedItem = item
            } label: {
                ItemCardView(item: item, userItemDataService: viewModel.userItemDataService)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: Helper views
    private func errorView(_ error: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            Text("Erreur")
                .font(.headline)
                .foregroundStyle(.primary)
            Text(error)
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
        .accessibilityElement(children: .combine)
    }

    private var noSearchResultsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
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
        .accessibilityElement(children: .combine)
    }

    private var emptyFavoritesView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)

            Text("Pas de favoris")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Ajoutez des articles à vos favoris pour les retrouver ici")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    HomeView()
}
