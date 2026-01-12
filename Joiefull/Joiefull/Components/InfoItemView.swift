import SwiftUI

struct InfoItemView: View {
    var label: String
    var price: Double
    var originalPrice: Double
    
    private var hasDiscount: Bool {
        originalPrice > price
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(label)
                    .foregroundStyle(Color.black)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(String(format: "%.2f €", price))
                    .foregroundStyle(Color.black)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.orange)
                    Text("4.2")
                        .foregroundStyle(Color.black)
                }
               
                if hasDiscount {
                    Text(String(format: "%.2f €", originalPrice))
                        .strikethrough()
                        .foregroundStyle(Color.black)
                        .opacity(0.7)
                }
            }
        }
        .font(Font.system(size: 14))
    }
}

#Preview {
    InfoItemView(label: "Veste urbaine", price: 89.99, originalPrice: 120.0)
        .padding()
}
