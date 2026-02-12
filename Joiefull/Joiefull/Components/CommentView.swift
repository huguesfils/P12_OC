import SwiftUI

struct CommentView: View {
    // MARK: Properties
    let itemId: Int
    let currentComment: String
    @Binding var localComment: String

    // MARK: Body
    var body: some View {
        TextField("Partagez ici vos impressions sur cette pièce", text: $localComment, axis: .vertical)
            .lineLimit(5...10)
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(.rect(cornerRadius: 12))
            .accessibilityLabel("Votre commentaire")
            .accessibilityHint("Partagez vos impressions sur cet article")
            .onChange(of: itemId) { _, _ in
                localComment = currentComment
            }
            .onAppear {
                localComment = currentComment
            }
    }
}
