//
//  ImagePostView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI

struct FeedImageView: View {
    let viewModel: PostViewModel

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
        viewModel.loadImage { result in
            switch result {
            case let .success(data):
                if let downloadedImage = UIImage(data: data) {
                    self.image = downloadedImage
                }
            case .failure(let error):
                print("Error loading image: \(error)")
            }
        }
    }
}
