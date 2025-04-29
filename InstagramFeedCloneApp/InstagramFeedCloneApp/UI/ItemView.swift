//
//  ItemView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI
import InstagramFeedClone

struct ItemView: View {
    let viewModel: ItemViewModel
    
    var body: some View {
        
        switch viewModel.item.type {
        case .videoMp4:
            FeedVideoView(viewModel: viewModel)
            
        case .imageJPEG, .imagePNG, .imageGIF:
            FeedImageView(viewModel: viewModel)
        @unknown default:
            EmptyView()
        }
    }
}
