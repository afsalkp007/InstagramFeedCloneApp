//
//  VideoPostView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI
import AVKit

struct FeedVideoView: View {
    let url: URL
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
        CacheManager.shared.getCachedData(for: url) { data in
            if let data = data {
                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                try? data.write(to: tempURL)
                DispatchQueue.main.async {
                    self.player = AVPlayer(url: tempURL)
                }
            } else {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    if let data = data {
                        CacheManager.shared.cacheData(data, for: url)
                        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                        try? data.write(to: tempURL)
                        DispatchQueue.main.async {
                            self.player = AVPlayer(url: tempURL)
                        }
                    }
                }.resume()
            }
        }
    }
}
