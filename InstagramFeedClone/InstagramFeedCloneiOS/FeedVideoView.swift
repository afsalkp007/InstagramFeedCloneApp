//
//  FeedVideoView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI
import AVKit

public protocol FeedVideoViewDelegate {
    func didRequestVideo()
    func didCancelVideoLoad()
    
    var player: AVPlayer? { get }
    var cellHeight: CGFloat { get }
}

struct FeedVideoView: View {
    let delegate: FeedVideoViewDelegate
    
    var body: some View {
        Group {
            if let player = delegate.player {
                VideoPlayer(player: player)
                    .onAppear { player.play() }
                    .onDisappear { player.pause() }
                    .frame(height: delegate.cellHeight)
                    .cornerRadius(10)
            } else {
                ShimmerView()
                    .frame(height: delegate.cellHeight)
                    .cornerRadius(10)
                    .onAppear { delegate.didRequestVideo() }
                    .onDisappear { delegate.didCancelVideoLoad() }
            }
        }
    }
}
