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
    
    // MARK: Body
    @ViewBuilder
    var body: some View {
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
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                onToggle(itemId)
            }
        }
    }
}
