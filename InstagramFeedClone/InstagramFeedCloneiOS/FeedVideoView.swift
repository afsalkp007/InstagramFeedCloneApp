//
//  FeedVideoView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI
import AVKit
import InstagramFeedClone

struct FeedVideoView: View {
    let viewModel: FeedVideoViewModel
    
    var body: some View {
        Group {
            if let player = viewModel.player {
                VideoPlayer(player: player)
                    .onAppear { player.play() }
                    .onDisappear { player.pause() }
                    .frame(height: viewModel.cellHeight)
                    .cornerRadius(10)
            } else {
                ShimmerView()
                    .frame(height: viewModel.cellHeight)
                    .cornerRadius(10)
                    .onAppear { viewModel.didRequestVideo() }
                    .onDisappear { viewModel.didCancelVideoLoad() }
            }
        }
    }
}
