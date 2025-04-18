//
//  VideoPostView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI
import AVKit

struct FeedVideoView: View {
    let manager: FeedVideoViewModel
    
    var body: some View {
        VideoPlayer(player: manager.player())
            .onAppear {
                manager.play()
            }
            .onDisappear {
                manager.pause()
            }
            .frame(height: 300)
            .cornerRadius(10)
    }
}
