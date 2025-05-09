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
    let viewModel: MediaViewModel
    
    @State private var player: AVPlayer?
    @State private var cellHeight: CGFloat = 300
    
    private func tempURL() -> URL {
        return FileManager.default
            .temporaryDirectory
            .appendingPathComponent(viewModel.item.url.lastPathComponent)
    }
    
    var body: some View {
        Group {
            if let player = player {
                VideoPlayer(player: player)
                    .onAppear { player.play() }
                    .onDisappear { player.pause() }
                    .frame(height: cellHeight)
                    .cornerRadius(10)
            } else {
                ShimmerView()
                    .frame(height: cellHeight)
                    .cornerRadius(10)
                    .onAppear { loadVideo() }
                    .onDisappear { viewModel.cancelMediaLoad() }
            }
        }
    }
    
    private func loadVideo() {
        viewModel.loadMedia { result in
            guard let data = try? result.get() else { return }
            
            try? data.write(to: tempURL())
            self.player = AVPlayer(url: tempURL())
            try? self.calculateHeight()
        }
    }
    
    private func calculateHeight() throws {
        let asset = AVURLAsset(url: tempURL())
        
        Task { @MainActor in
            do {
                guard let videoTrack = try await asset.loadTracks(withMediaType: .video).first else { return }
                
                let videoSize = try await videoTrack.load(.naturalSize)
                let preferredTransform = try await videoTrack.load(.preferredTransform)
                let transformedSize = videoSize.applying(preferredTransform)
                let aspectRatio = abs(transformedSize.height / transformedSize.width)
                
                let calculatedHeight = UIScreen.main.bounds.width * aspectRatio
                let maxHeight = UIScreen.main.bounds.height * 0.5 // Adjust this value as needed
                
                self.cellHeight = min(calculatedHeight, maxHeight)
            } catch {
                print("Error calculating video height: \(error)")
            }
        }
    }
}
