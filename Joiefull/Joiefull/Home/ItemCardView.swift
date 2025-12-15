import SwiftUI

struct ItemCardView: View {
    let imageName: String
    let label: String
    let price: String
    let rating: String
    let oldPrice: String
    let initialLikeCount: Int
    
    init(imageName: String = "TestPreview",
         label: String = "Veste urbaine",
         price: String = "89",
         rating: String = "4.2",
         oldPrice: String = "120",
         initialLikeCount: Int = 0) {
        self.imageName = imageName
        self.label = label
        self.price = price
        self.rating = rating
        self.oldPrice = oldPrice
        self.initialLikeCount = initialLikeCount
    }
    
    var body: some View {
        VStack(spacing: 0) {
            PhotoView(imageName: imageName,
                      initialLikeCount: initialLikeCount)
            
            InfoItemView(label: label,
                         price: price,
                         rating: rating,
                         oldPrice: oldPrice)
            .padding(8)
            
        }
        .frame(width: 200)
    }
}

#Preview {
    ItemCardView()
        .padding()
}
