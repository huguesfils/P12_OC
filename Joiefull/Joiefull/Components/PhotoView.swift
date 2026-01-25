import SwiftUI

struct PhotoView: View {
    // MARK: Properties
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let imageURL: String?
    let imageName: String?
    let customHeight: CGFloat?
    let customMaxWidth: CGFloat?
    let initialLikeCount: Int
    
    private var imageHeight: CGFloat {
        customHeight ?? (horizontalSizeClass == .compact ? 200 : 250)
    }
    
    private var maxWidth: CGFloat {
        customMaxWidth ?? 200
    }
    
    init(imageURL: String? = nil, imageName: String? = nil, initialLikeCount: Int = 0, customHeight: CGFloat? = nil, customMaxWidth: CGFloat? = nil) {
        self.imageURL = imageURL
        self.imageName = imageName
        self.initialLikeCount = initialLikeCount
        self.customHeight = customHeight
        self.customMaxWidth = customMaxWidth
    }
    
    // MARK: Body
    var body: some View {
        Group {
            if let imageURL = imageURL, let url = URL(string: imageURL) {
                CachedAsyncImage(url: url)
                    .clipped()
            } else if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: maxWidth, maxHeight: imageHeight)
        .clipped()
        .cornerRadius(20)
        .overlay(alignment: .bottomTrailing) {
            LikeBadgeView(initialLikeCount: initialLikeCount)
                .padding(.trailing, 12)
                .padding(.bottom, 12)
        }
    }
}
