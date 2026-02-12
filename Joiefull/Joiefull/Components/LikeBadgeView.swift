import SwiftUI

struct LikeBadgeView: View {
    // MARK: Properties
    let itemId: Int
    let isFavorite: Bool
    let initialLikeCount: Int
    let onToggle: (Int) -> Void
    
    private var displayCount: Int {
        initialLikeCount + (isFavorite ? 1 : 0)
    }

    private var accessibilityLabelText: String {
        isFavorite ? "Retirer des favoris" : "Ajouter aux favoris"
    }

    private var accessibilityValueText: String {
        "\(displayCount) j'aime"
    }

    // MARK: Body
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                onToggle(itemId)
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(isFavorite ? .red : .primary)
                    .font(.system(size: 14))

                Text("\(displayCount)")
                    .foregroundStyle(.primary)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color(uiColor: .systemBackground))
                    .shadow(color: .primary.opacity(0.1), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabelText)
        .accessibilityValue(accessibilityValueText)
        .accessibilityHint("Double-tapez pour modifier")
    }
}
