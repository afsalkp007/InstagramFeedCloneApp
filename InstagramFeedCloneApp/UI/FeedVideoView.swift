//
//  VideoPostView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI
import AVKit

struct FeedVideoView: View {    
    let viewModel: PostViewModel
    
    @State private var player: AVPlayer?

    var body: some View {
        Group {
            if let player = player {
                VideoPlayer(player: player)
                    .onAppear {
                        player.play()
                    }
                    .onDisappear {
                        player.pause()
                    }
                    .frame(height: 300)
                    .cornerRadius(10)
            } else {
                ShimmerView()
                    .frame(height: 300)
                    .cornerRadius(10)
                    .onAppear {
                        loadVideo()
                    }
            }
        }
    }

    private func loadVideo() {
        viewModel.loadVideo { result in
            switch result {
            case let .success(url):
                DispatchQueue.main.async {
                    self.player = AVPlayer(url: url)
                }
            case .failure(let error):
                print("Error loading video: \(error)")
            }
        }
    }
}
