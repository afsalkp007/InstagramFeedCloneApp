//
//  FeedImageView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI
import InstagramFeedClone

struct FeedImageView: View {
    @State var image: UIImage?
    @State var cellHeight: CGFloat = 300

    let viewModel: MediaViewModel
    
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
                    .onAppear { loadImage() }
                    .onDisappear { viewModel.cancelMediaLoad() }
            }
        }
        .frame(height: cellHeight)
    }
    
    private func loadImage() {
            viewModel.loadMedia { result in
                switch result {
                case let .success(data):
                    if let downloadedImage = UIImage(data: data) {
                        self.image = downloadedImage
                        self.calculateHeight(for: downloadedImage)
                    }
                case .failure:
                    self.image = nil
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
