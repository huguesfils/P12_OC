import SwiftUI

public struct ItemCardView: View {
    let item: Item
    
    @ViewBuilder
    public var body: some View {
        VStack(spacing: 0) {
            PhotoView(imageURL: item.picture.url,
                      initialLikeCount: item.likes)
            
            InfoItemView(label: item.name,
                         price: item.price,
                         originalPrice: item.originalPrice)
            .padding(8)
            
        }
        .frame(width: 200)
    }
}
