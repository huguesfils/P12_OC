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
                         originalPrice: item.original_price)
            .padding(8)
            
        }
        .frame(width: 200)
    }
}

#Preview {
    let sampleItem = Item(
        id: 0,
        picture: Picture(
            url: "",
            description: "Sac à main orange posé sur une poignée de porte"
        ),
        name: "Sac à main orange",
        category: "ACCESSORIES",
        likes: 56,
        price: 69.99,
        original_price: 69.99
    )

    VStack(spacing: 0) {
        PhotoView(imageName: "TestPreview", initialLikeCount: sampleItem.likes)
        
        InfoItemView(label: sampleItem.name,
                     price: sampleItem.price,
                     originalPrice: sampleItem.original_price)
        .padding(8)
    }
    .frame(width: 200)
    .padding()
}
