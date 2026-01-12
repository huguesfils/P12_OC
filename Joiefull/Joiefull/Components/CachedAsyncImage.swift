import SwiftUI

struct CachedAsyncImage: View {
    //MARK: Properties
    let url: URL?
    @State private var uiImage: UIImage?
    @State private var isLoading: Bool = true
    
    //MARK: Body
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
    
    //MARK: Private methods
    private func loadImage() async {
        guard let url else {
            isLoading = false
            return
        }
        
        if let cached = ImageCache.shared.getImage(for: url) {
            print("[Cache] Image trouvée: \(url.lastPathComponent)")
            uiImage = cached
            isLoading = false
            return
        }
        
        print("[Download] Téléchargement: \(url.lastPathComponent)")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                isLoading = false
                return
            }
            
            ImageCache.shared.setImage(image, for: url)
            print("[Cache] Image stockée: \(url.lastPathComponent)")
            
            uiImage = image
        } catch {
            print("[Error] \(error.localizedDescription)")
        }
        
        isLoading = false
    }
}
