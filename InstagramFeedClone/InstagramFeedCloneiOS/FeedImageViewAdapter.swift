//
//  FeedImageViewAdapter.swift
//  InstagramFeedCloneiOS
//
//  Created by Mohamed Afsal on 30/04/2025.
//

import SwiftUI
import InstagramFeedClone

@Observable
final class FeedImageViewAdapter: FeedImageViewDelegate {
    var image: UIImage?
    var cellHeight: CGFloat = 300
        
    private let viewModel: ItemViewModel
    
    init(viewModel: ItemViewModel) {
        self.viewModel = viewModel
    }
    
    func didLoadImage() {
        viewModel.loadMedia { result in
            if let data = try? result.get(), let downloadedImage = UIImage(data: data) {
                self.image = downloadedImage
                self.calculateHeight(for: downloadedImage)
            }
        }
    }
    
    func didCancelLoadingImage() {
        viewModel.cancelMediaLoad()
    }
    
    private func calculateHeight(for image: UIImage) {
        let aspectRatio = image.size.height / image.size.width
        let calculatedHeight = UIScreen.main.bounds.width * aspectRatio
        let maxHeight = UIScreen.main.bounds.height * 0.5
        self.cellHeight = min(calculatedHeight, maxHeight)
    }
}
