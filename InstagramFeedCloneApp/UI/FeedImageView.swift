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
            ShimmerView()
                .frame(height: 300)
                .cornerRadius(10)
        }
        .frame(height: 300)
    }
}
