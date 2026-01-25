import SwiftUI

struct DetailView: View {
    // MARK: Properties
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var userRating: Int = 0
    @State private var userComment: String = ""
    let item: Item?
    
    private var photoMaxHeight: CGFloat {
        horizontalSizeClass == .regular ? 600 : 400
    }
    
    // MARK: Body
    @ViewBuilder
    var body: some View {
        if let item = item {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    PhotoView(
                        imageURL: item.picture.url,
                        initialLikeCount: item.likes,
                        customHeight: photoMaxHeight,
                        customMaxWidth: .infinity
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
                    
                    HStack(spacing: 12) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.secondary)
                        
                        HStack(spacing: 8) {
                            ForEach(1...5, id: \.self) { star in
                                Button(action: {
                                    userRating = star
                                }) {
                                    Image(systemName: star <= userRating ? "star.fill" : "star")
                                        .font(.system(size: 28))
                                        .foregroundStyle(star <= userRating ? .orange : .secondary)
                                }
                            }
                        }
                    }
                    
                    TextField("Partagez ici vos impressions sur cette pièce", text: $userComment, axis: .vertical)
                        .lineLimit(5...10)
                        .padding(12)
                        .background(Color(uiColor: .systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Spacer()
                }
                .padding()
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
