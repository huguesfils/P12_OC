import SwiftUI

struct HomeView: View {
    let items: [ItemData] = [
        ItemData(imageName: "TestPreview", label: "Veste urbaine", price: "89", rating: "4.3", oldPrice: "120", initialLikeCount: 24),
        ItemData(imageName: "TestPreview", label: "Pull torsadé", price: "69", rating: "4.6", oldPrice: "95", initialLikeCount: 56),
        ItemData(imageName: "TestPreview", label: "Pantalon slim", price: "79", rating: "4.1", oldPrice: "110", initialLikeCount: 12),
        ItemData(imageName: "TestPreview", label: "Chemise élégante", price: "59", rating: "4.5", oldPrice: "85", initialLikeCount: 33)
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(items) { item in
                    ItemCardView(
                        imageName: item.imageName,
                        label: item.label,
                        price: item.price,
                        rating: item.rating,
                        oldPrice: item.oldPrice,
                        initialLikeCount: item.initialLikeCount
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    HomeView()
}
