import SwiftUI

struct PhotoView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let imageURL: String?
    let imageName: String?
    @State private var isLiked: Bool = false
    @State private var likeCount: Int
    
    
    private var imageHeight: CGFloat {
        horizontalSizeClass == .compact ? 200 : 250
    }
    
    init(imageURL: String? = nil, imageName: String? = nil, initialLikeCount: Int = 0) {
        self.imageURL = imageURL
        self.imageName = imageName
        _likeCount = State(initialValue: initialLikeCount)
    }
    
    var body: some View {
        Group {
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: 200, maxHeight: imageHeight)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: 200, maxHeight: imageHeight)
        .clipped()
        .cornerRadius(20)
        .overlay(alignment: .bottomTrailing) {
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
        PhotoView(imageName: "TestPreview", initialLikeCount: 56)
    }
    .padding()
}
