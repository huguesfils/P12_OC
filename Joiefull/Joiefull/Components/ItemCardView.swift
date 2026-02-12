import SwiftUI
import SwiftData

struct ItemCardView: View {
    // MARK: Properties
    @Query private var allUserData: [UserItemData]
    let userItemDataService: UserItemDataServiceProtocol
    let item: Item

    private var isFavorite: Bool {
        allUserData.first?.isFavorite ?? false
    }

    init(item: Item, userItemDataService: UserItemDataServiceProtocol) {
        self.item = item
        self.userItemDataService = userItemDataService

        let itemId = item.id
        let predicate = #Predicate<UserItemData> { data in
            data.itemId == itemId
        }
        _allUserData = Query(filter: predicate)
    }

    // MARK: Body
    var body: some View {
        VStack(spacing: 0) {
            PhotoView(
                itemId: item.id,
                imageURL: item.picture.url,
                imageDescription: item.picture.description,
                initialLikeCount: item.likes,
                isFavorite: isFavorite,
                onToggleFavorite: { itemId in
                    Task {
                        do {
                            try await userItemDataService.toggleFavorite(itemId: itemId)
                        } catch {
                            AppLogger.error(error)
                        }
                    }
                }
            )

            InfoItemView(
                label: item.name,
                price: item.price,
                originalPrice: item.originalPrice
            )
            .padding(8)
        }
        .frame(width: 200)
        .accessibilityHint("Double-tapez pour voir les détails")
    }
}
