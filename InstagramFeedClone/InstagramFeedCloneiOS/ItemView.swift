//
//  ItemView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI
import InstagramFeedClone

struct ItemView: View {
    @State var viewModel: ItemViewModel
    
    var body: some View {
        
        switch viewModel.item.type {
        case .videoMp4:
            let delegate = FeedVideoViewAdapter(viewModel: viewModel)
            FeedVideoView(delegate: delegate)
            
        case .imageJPEG, .imagePNG, .imageGIF:
            let adapter = FeedImageViewAdapter(viewModel: viewModel)
            FeedImageView(delegate: adapter)
        default:
            EmptyView()
        }
    }
}
