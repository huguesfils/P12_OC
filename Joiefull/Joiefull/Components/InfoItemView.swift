import SwiftUI

struct InfoItemView: View {
    enum Style {
        case compact
        case regular
        
        var titleFont: Font {
            switch self {
            case .compact: return .system(size: 14, weight: .semibold)
            case .regular: return .title3
            }
        }
        
        var priceFont: Font {
            switch self {
            case .compact: return .system(size: 14)
            case .regular: return .body
            }
        }
        
        var ratingFont: Font {
            switch self {
            case .compact: return .system(size: 14)
            case .regular: return .subheadline
            }
        }
        
        var spacing: CGFloat {
            switch self {
            case .compact: return 8
            case .regular: return 12
            }
        }
    }
    
    var label: String
    var price: Double
    var originalPrice: Double
    var style: Style
    
    init(label: String, price: Double, originalPrice: Double, style: Style = .compact) {
        self.label = label
        self.price = price
        self.originalPrice = originalPrice
        self.style = style
    }
    
    private var hasDiscount: Bool {
        originalPrice > price
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: style.spacing) {
                Text(label)
                    .font(style.titleFont)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.black)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text(String(format: "%.0f€", price))
                    .font(style.priceFont)
                    .foregroundStyle(Color.black)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: style.spacing) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Color.orange)
                        .font(style.ratingFont)
                    Text("4.6")
                        .font(style.ratingFont)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.black)
                }
               
                if hasDiscount {
                    Text(String(format: "%.0f€", originalPrice))
                        .font(style.priceFont)
                        .strikethrough()
                        .foregroundStyle(Color.secondary)
                }
            }
        }
    }
}
