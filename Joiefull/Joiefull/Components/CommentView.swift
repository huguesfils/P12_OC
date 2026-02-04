import SwiftUI

struct CommentView: View {
    // MARK: Properties
    let itemId: Int
    let currentComment: String
    @Binding var localComment: String

    // MARK: Body
    @ViewBuilder
    var body: some View {
        TextField("Partagez ici vos impressions sur cette pièce", text: $localComment, axis: .vertical)
            .lineLimit(5...10)
            .padding(12)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onChange(of: itemId) { _, _ in
                localComment = currentComment
            }
            .onAppear {
                localComment = currentComment
            }
    }
}
