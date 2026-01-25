import SwiftUI
import SwiftData

public struct ItemCardView: View {
    // MARK: Properties
    @Query private var allUserData: [UserItemData]
    let userItemDataService: UserItemDataServiceProtocol
    let item: Item

    private var isFavorite: Bool {
        allUserData.first { $0.itemId == item.id }?.isFavorite ?? false
    }

    public init(item: Item, userItemDataService: UserItemDataServiceProtocol) {
        self.item = item
        self.userItemDataService = userItemDataService

        let itemId = item.id
        let predicate = #Predicate<UserItemData> { data in
            data.itemId == itemId
        }
        _allUserData = Query(filter: predicate)
    }

    // MARK: Body
    @ViewBuilder
    public var body: some View {
        VStack(spacing: 0) {
            PhotoView(
                itemId: item.id,
                imageURL: item.picture.url,
                initialLikeCount: item.likes,
                isFavorite: isFavorite,
                onToggleFavorite: { itemId in
                    Task {
                        try? await userItemDataService.toggleFavorite(itemId: itemId)
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
    }
}
