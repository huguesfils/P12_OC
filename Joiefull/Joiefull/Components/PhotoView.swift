import SwiftUI

struct PhotoView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let imageName: String
    @State private var isLiked: Bool = false
    @State private var likeCount: Int
    
    
    private var imageHeight: CGFloat {
        horizontalSizeClass == .compact ? 200 : 250
    }
    
    init(imageName: String = "", initialLikeCount: Int = 0) {
        self.imageName = imageName
        _likeCount = State(initialValue: initialLikeCount)
    }
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: 200, maxHeight: imageHeight)
            .clipped()
            .cornerRadius(20)
            .overlay(alignment: .bottomTrailing) {
                HStack(spacing: 6) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .black)
                        .font(.system(size: 16))
                    
                    Text("\(likeCount)")
                        .foregroundColor(.black)
                        .font(.system(size: 14, weight: .medium))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isLiked.toggle()
                        if isLiked {
                            likeCount += 1
                        } else {
                            likeCount = max(0, likeCount - 1)
                        }
                    }
                }
                .padding(.trailing, 12)
                .padding(.bottom, 12)
            }
    }
}

#Preview {
    VStack(spacing: 20) {
        PhotoView(imageName: "TestPreview", initialLikeCount: 24)
    }
    .padding()
}
