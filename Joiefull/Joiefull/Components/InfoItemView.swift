import SwiftUI

struct InfoItemView: View {
    var label: String
    var price: String
    var rating: String
    var oldPrice: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(label)
                    .foregroundStyle(Color.black)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text("\(price) €")
                    .foregroundStyle(Color.black)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.orange)
                    Text(rating)
                        .foregroundStyle(Color.black)
                }
               
                Text("\(oldPrice) €")
                    .strikethrough()
                    .foregroundStyle(Color.black)
                    .opacity(0.7)
            }
        }
    }
}

#Preview {
    InfoItemView(label: "Veste urbaine", price: "89", rating: "4.2", oldPrice: "120")
        .padding()
}
