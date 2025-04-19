//
//  PostView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI

struct PostView: View {
    let media: Media
    
    var body: some View {
        
        switch media.type {
        case .videoMp4:
            FeedVideoView(url: media.url)
            
        case .imageJPEG, .imagePNG, .imageGIF:
            FeedImageView(url: media.url)
        }
    }
}
