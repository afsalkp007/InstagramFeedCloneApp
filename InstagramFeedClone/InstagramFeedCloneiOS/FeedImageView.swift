//
//  FeedImageView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI

public protocol FeedImageViewDelegate {
    func didLoadImage()
    func didCancelLoadingImage()
    
    var image: UIImage? { get }
    var cellHeight: CGFloat { get }
}

struct FeedImageView: View {
    var delegate: FeedImageViewDelegate
    
    var body: some View {
        Group {
            if let image = delegate.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(height: delegate.cellHeight)
                    .cornerRadius(10)
            } else {
                ShimmerView()
                    .frame(height: delegate.cellHeight)
                    .cornerRadius(10)
                    .onAppear { delegate.didLoadImage() }
                    .onDisappear { delegate.didCancelLoadingImage() }
            }
        }
        .frame(height: delegate.cellHeight)
    }
}
