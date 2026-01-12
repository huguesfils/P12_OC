import SwiftUI

struct LikeBadgeView: View {
    // MARK: Properties
    @State private var isLiked: Bool = false
    @State private var likeCount: Int
    
    init(initialLikeCount: Int = 0) {
        _likeCount = State(initialValue: initialLikeCount)
    }
    
    // MARK: Body
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .foregroundColor(isLiked ? .red : .black)
                .font(.system(size: 14))
            
            Text("\(likeCount)")
                .foregroundColor(.black)
                .font(.system(size: 14, weight: .medium))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isLiked.toggle()
                likeCount += isLiked ? 1 : -1
                likeCount = max(0, likeCount)
            }
        }
    }
}
