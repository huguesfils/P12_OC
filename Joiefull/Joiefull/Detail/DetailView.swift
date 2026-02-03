import SwiftUI
import SwiftData

struct DetailView: View {
    // MARK: Properties
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = DetailViewModel()
    @State private var localComment: String = ""
    @Query private var allUserData: [UserItemData]

    let item: Item?
    let onDismiss: () -> Void

    private var photoMaxHeight: CGFloat {
        horizontalSizeClass == .regular ? 600 : 400
    }

    private var userData: UserItemData? {
        guard let item = item else { return nil }
        return allUserData.first { $0.itemId == item.id }
    }
    
    // MARK: Body
    @ViewBuilder
    var body: some View {
        if let item = item {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    PhotoView(
                        itemId: item.id,
                        imageURL: item.picture.url,
                        initialLikeCount: item.likes,
                        isFavorite: userData?.isFavorite ?? false,
                        customHeight: photoMaxHeight,
                        customMaxWidth: .infinity,
                        onToggleFavorite: { [weak viewModel] itemId in
                            Task {
                                await viewModel?.toggleFavorite(itemId: itemId)
                            }
                        }
                    )

                    InfoItemView(
                        label: item.name,
                        price: item.price,
                        originalPrice: item.originalPrice,
                        style: .regular
                    )

                    Text(item.picture.description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)

                    RatingView(
                        itemId: item.id,
                        currentRating: userData?.rating ?? 0,
                        onRatingChange: { [weak viewModel] itemId, rating in
                            Task {
                                await viewModel?.saveRating(itemId: itemId, rating: rating)
                            }
                        }
                    )

                    CommentView(
                        itemId: item.id,
                        currentComment: userData?.comment ?? "",
                        localComment: $localComment
                    )

                    Spacer()
                }
                .padding()
            }
            .onChange(of: item.id) { oldId, newId in
                if oldId != newId, localComment != (allUserData.first { $0.itemId == oldId }?.comment ?? "") {
                    let commentToSave = localComment
                    Task {
                        await viewModel.setComment(itemId: oldId, comment: commentToSave)
                    }
                }
            }
            .onDisappear {
                if localComment != (userData?.comment ?? "") {
                    Task {
                        await viewModel.setComment(itemId: item.id, comment: localComment)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        } else {
            VStack(spacing: 20) {
                Image(systemName: "hand.tap")
                    .font(.system(size: 80))
                    .foregroundStyle(.secondary)
                Text("Sélectionnez un article")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
