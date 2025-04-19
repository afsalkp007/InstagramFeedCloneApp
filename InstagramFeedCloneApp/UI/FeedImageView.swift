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
    @State private var cellHeight: CGFloat = 300

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(height: cellHeight)
                    .cornerRadius(10)
            } else {
                ShimmerView()
                    .frame(height: cellHeight)
                    .cornerRadius(10)
                    .onAppear {
                        loadImage()
                    }
            }
        }
        .frame(height: cellHeight)
    }

    private func loadImage() {
        viewModel.loadImage { result in
            switch result {
            case let .success(data):
                if let downloadedImage = UIImage(data: data) {
                    self.image = downloadedImage
                    self.calculateHeight(for: downloadedImage)
                }
            case .failure(let error):
                print("Error loading image: \(error)")
            }
        }
    }

    private func calculateHeight(for image: UIImage) {
        let aspectRatio = image.size.height / image.size.width
        let calculatedHeight = UIScreen.main.bounds.width * aspectRatio
        let maxHeight = UIScreen.main.bounds.height * 0.5
        self.cellHeight = min(calculatedHeight, maxHeight)
    }
}
