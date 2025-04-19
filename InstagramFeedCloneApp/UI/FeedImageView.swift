//
//  ImagePostView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI

struct FeedImageView: View {
    let url: URL

    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(height: 300)
                    .cornerRadius(10)
            } else {
                ShimmerView()
                    .frame(height: 300)
                    .cornerRadius(10)
                    .onAppear {
                        loadImage()
                    }
            }
        }
        .frame(height: 300)
    }

    private func loadImage() {
        CacheManager.shared.getCachedData(for: url) { data in
            if let data = data, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = downloadedImage
                }
            } else {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data, let downloadedImage = UIImage(data: data) {
                        CacheManager.shared.cacheData(data, for: url)
                        DispatchQueue.main.async {
                            self.image = downloadedImage
                        }
                    }
                }.resume()
            }
        }
    }
}
