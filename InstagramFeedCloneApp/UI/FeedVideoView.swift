//
//  VideoPostView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI
import AVKit

struct FeedVideoView: View {
    let viewModel: FeedVideoViewModel
    
    var body: some View {
        VideoPlayer(player: viewModel.player())
            .onAppear {
                viewModel.play()
            }
            .onDisappear {
                viewModel.pause()
            }
            .frame(height: 300)
            .cornerRadius(10)
    }
}
