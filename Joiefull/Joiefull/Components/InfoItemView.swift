import SwiftUI

struct InfoItemView: View {
    // MARK: Enum
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
    
    // MARK: Properties
    var label: String
    var price: Double
    var originalPrice: Double
    var style: Style
    
    private var hasDiscount: Bool {
        originalPrice > price
    }

    private var accessibilityText: String {
        var text = "\(label), \(Int(price)) euros"
        if hasDiscount {
            text += ", prix original \(Int(originalPrice)) euros"
        }
        text += ", note moyenne 4.6 sur 5"
        return text
    }

    init(label: String, price: Double, originalPrice: Double, style: Style = .compact) {
        self.label = label
        self.price = price
        self.originalPrice = originalPrice
        self.style = style
    }

    // MARK: Body
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: style.spacing) {
                Text(label)
                    .font(style.titleFont)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(price, format: .currency(code: "EUR").precision(.fractionLength(0)))
                    .font(style.priceFont)
                    .foregroundStyle(.primary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: style.spacing) {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.orange)
                        .font(style.ratingFont)
                    Text("4.6")
                        .font(style.ratingFont)
                        .fontWeight(.medium)
                        .foregroundStyle(.primary)
                }

                if hasDiscount {
                    Text(originalPrice, format: .currency(code: "EUR").precision(.fractionLength(0)))
                        .font(style.priceFont)
                        .strikethrough()
                        .foregroundStyle(.secondary)
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityText)
    }
}
