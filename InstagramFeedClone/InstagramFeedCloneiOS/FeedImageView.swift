//
//  FeedImageView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI
import InstagramFeedClone

struct FeedImageView: View {
    var viewModel: FeedImageViewModel
    
    var body: some View {
        Group {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .frame(height: viewModel.cellHeight)
                    .cornerRadius(10)
            } else {
                ShimmerView()
                    .frame(height: viewModel.cellHeight)
                    .cornerRadius(10)
                    .onAppear { viewModel.didLoadImage() }
                    .onDisappear { viewModel.didCancelLoadingImage() }
            }
        }
        .frame(height: viewModel.cellHeight)
    }
}
