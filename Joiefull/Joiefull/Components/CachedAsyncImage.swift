import SwiftUI

struct CachedAsyncImage: View {
    // MARK: Properties
    @State private var uiImage: UIImage?
    @State private var isLoading: Bool = true

    let url: URL?

    // MARK: Body
    @ViewBuilder
    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if isLoading {
                ProgressView()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .task(id: url) {
            await loadImage()
        }
    }

    // MARK: Private methods
    private func loadImage() async {
        guard let url else {
            isLoading = false
            return
        }

        guard !Task.isCancelled else { return }

        if let cached = ImageCache.shared.getImage(for: url) {
            uiImage = cached
            isLoading = false
            return
        }

        guard !Task.isCancelled else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            guard !Task.isCancelled else { return }

            guard let image = UIImage(data: data) else {
                isLoading = false
                return
            }

            ImageCache.shared.setImage(image, for: url)

            guard !Task.isCancelled else { return }

            uiImage = image
        } catch is CancellationError {
            return
        } catch {
            AppLogger.error(error)
            isLoading = false
        }

        isLoading = false
    }
}
