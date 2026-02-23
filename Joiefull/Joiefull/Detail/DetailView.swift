import SwiftUI
import SwiftData

struct DetailView: View {
    // MARK: Properties
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var viewModel = DetailViewModel()
    @State private var localComment: String = ""
    @Query private var allUserData: [UserItemData]

    let item: Item?

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
                        imageDescription: item.picture.description,
                        initialLikeCount: item.likes,
                        isFavorite: userData?.isFavorite ?? false,
                        customHeight: photoMaxHeight,
                        customMaxWidth: .infinity,
                        onToggleFavorite: { itemId in
                            Task {
                                await viewModel.toggleFavorite(itemId: itemId)
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
                        .accessibilityLabel(item.picture.description)

                    RatingView(
                        itemId: item.id,
                        currentRating: userData?.rating ?? 0,
                        onRatingChange: { itemId, rating in
                            Task {
                                await viewModel.saveRating(itemId: itemId, rating: rating)
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
            .scrollDismissesKeyboard(.immediately)
            .onChange(of: item.id) { oldId, newId in
                if oldId != newId, localComment != (allUserData.first { $0.itemId == oldId }?.comment ?? "") {
                    let service = viewModel.userItemDataService
                    let commentToSave = localComment
                    Task {
                        try await service.setComment(itemId: oldId, comment: commentToSave)
                    }
                }
            }
            .onDisappear {
                if localComment != (userData?.comment ?? "") {
                    let service = viewModel.userItemDataService
                    let commentToSave = localComment
                    Task {
                        try await service.setComment(itemId: item.id, comment: commentToSave)
                    }
                }
            }
            .task {
                await viewModel.loadShareImage(from: item.picture.url)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        shareItem(item)
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .accessibilityLabel("Partager cet article")
                }
            }
        } else {
            VStack(spacing: 20) {
                Image(systemName: "hand.tap")
                    .font(.system(size: 80))
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
                Text("Sélectionnez un article")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Sélectionnez un article pour voir ses détails")
        }
    }

    // MARK: Share

    private func shareItem(_ item: Item) {
        let priceText = String(format: "%.2f", item.price)
        var items: [Any] = ["\(item.name) - \(priceText)€\n\(item.picture.description)"]
        if let image = viewModel.shareImage {
            items.append(image)
        }
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.keyWindow?.rootViewController else { return }

        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = rootVC.view
            popover.sourceRect = CGRect(x: rootVC.view.bounds.midX, y: 0, width: 0, height: 0)
            popover.permittedArrowDirections = .up
        }

        rootVC.present(activityVC, animated: true)
    }
}
