import SwiftUI

struct RatingView: View {
    // MARK: Properties
    let itemId: Int
    let currentRating: Int
    let onRatingChange: (Int, Int) -> Void

    // MARK: Body
    @ViewBuilder
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray.opacity(0.5))

            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { star in
                    Button(action: {
                        onRatingChange(itemId, star)
                    }) {
                        Image(systemName: star <= currentRating ? "star.fill" : "star")
                            .font(.system(size: 28))
                            .foregroundColor(star <= currentRating ? .orange : .gray.opacity(0.4))
                    }
                }
            }
        }
    }
}
