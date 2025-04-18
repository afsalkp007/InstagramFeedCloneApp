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
            VideoPostView(manager: VideoManager(url: image.url))
            
        case .imageJPEG, .imagePNG:
            ImagePostView(url: image.url)
        }
    }
}
