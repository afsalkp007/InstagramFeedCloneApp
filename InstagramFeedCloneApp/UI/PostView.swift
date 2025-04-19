//
//  PostView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI

struct PostView: View {
    let image: Image
    
    var body: some View {
        
        switch image.type {
        case .videoMp4:
            FeedVideoView(viewModel: FeedVideoViewModel(url: image.url))
            
        case .imageJPEG, .imagePNG, .imageGIF:
            FeedImageView(url: image.url)
        }
    }
}
