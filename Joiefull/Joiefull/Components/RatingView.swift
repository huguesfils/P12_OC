import SwiftUI

struct RatingView: View {
    // MARK: Properties
    let itemId: Int
    let currentRating: Int
    let onRatingChange: (Int, Int) -> Void

    // MARK: Body
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(.gray.opacity(0.5))
                .accessibilityHidden(true)

            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { star in
                    Button {
                        onRatingChange(itemId, star)
                    } label: {
                        Image(systemName: star <= currentRating ? "star.fill" : "star")
                            .font(.system(size: 28))
                            .foregroundStyle(star <= currentRating ? .orange : .gray.opacity(0.4))
                    }
                    .accessibilityLabel("Note \(star) sur 5")
                    .accessibilityAddTraits(star == currentRating ? .isSelected : [])
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Évaluation")
            .accessibilityValue(currentRating > 0 ? "\(currentRating) sur 5 étoiles" : "Aucune note")
            .accessibilityHint("Sélectionnez une étoile pour noter")
        }
    }
}
