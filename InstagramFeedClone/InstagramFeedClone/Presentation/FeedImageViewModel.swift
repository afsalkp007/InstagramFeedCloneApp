//
//  FeedImageViewAdapter.swift
//  InstagramFeedCloneiOS
//
//  Created by Mohamed Afsal on 30/04/2025.
//

import SwiftUI

@Observable
public final class FeedImageViewModel {
    public var image: UIImage?
    public var cellHeight: CGFloat = 300
    
    private let viewModel: MediaViewModel
    
    public init(viewModel: MediaViewModel) {
        self.viewModel = viewModel
    }
}
 
extension FeedImageViewModel {
    public func didLoadImage() {
        viewModel.loadMedia { result in
            if let data = try? result.get(), let downloadedImage = UIImage(data: data) {
                self.image = downloadedImage
                self.calculateHeight(for: downloadedImage)
            }
        }
    }
    
    public func didCancelLoadingImage() {
        viewModel.cancelMediaLoad()
    }
}
 
extension FeedImageViewModel {
    private func calculateHeight(for image: UIImage) {
        let aspectRatio = image.size.height / image.size.width
        let calculatedHeight = UIScreen.main.bounds.width * aspectRatio
        let maxHeight = UIScreen.main.bounds.height * 0.5
        self.cellHeight = min(calculatedHeight, maxHeight)
    }
}
