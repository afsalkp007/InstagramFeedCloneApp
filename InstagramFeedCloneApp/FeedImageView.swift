//
//  ImagePostView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI

struct FeedImageView: View {
    let url: URL
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .frame(height: 300)
                .cornerRadius(10)
        } placeholder: {
            ProgressView()
        }
        .frame(height: 300)
    }
}
