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
            VideoPostView(manager: VideoManager(url: URL(string: image.link)!))
            
        case .imageJPEG, .imagePNG:
            ImagePostView(url: URL(string: image.link)!)
        }
    }
}
