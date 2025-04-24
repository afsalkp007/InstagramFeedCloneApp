//
//  VideoPostView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI
import AVKit
import InstagramFeedClone

struct FeedVideoView: View {
    let viewModel: PostViewModel
    
    @State private var player: AVPlayer?
    @State private var cellHeight: CGFloat = 300
    
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
                    .frame(height: cellHeight)
                    .cornerRadius(10)
            } else {
                ShimmerView()
                    .frame(height: cellHeight)
                    .cornerRadius(10)
                    .onAppear {
                        loadVideo()
                    }
                    .onDisappear {
                        viewModel.cancelMediaLoad()
                    }
            }
        }
    }
    
    private func loadVideo() {
        let url = viewModel.media.url
        viewModel.loadMedia { result in
            if case let .success(data) = result {
                writeDataToTempURL(data: data, url: url) { result in
                    if case let .success(url) = result {
                        self.player = AVPlayer(url: url)
                        self.calculateHeight(for: url)
                    }
                }
                    
            }
        }
    }
    
    public typealias URLCompletion = (Result<URL, Error>) -> Void
    
    private func writeDataToTempURL(data: Data, url: URL, completion: @escaping (URLCompletion)) {
        do {
            try data.write(to: tempURL)
            completion(.success(tempURL))
        } catch {
            completion(.failure(error))
        }
    }
    
    private var tempURL: URL {
        return FileManager.default.temporaryDirectory.appendingPathComponent(viewModel.media.url.lastPathComponent)
    }
    
    private func calculateHeight(for videoURL: URL) {
        let asset = AVURLAsset(url: videoURL)
        
        Task {
            do {
                let tracks = try await asset.loadTracks(withMediaType: .video)
                guard let videoTrack = tracks.first else { return }
                
                let videoSize = try await videoTrack.load(.naturalSize)
                let preferredTransform = try await videoTrack.load(.preferredTransform)
                let transformedSize = videoSize.applying(preferredTransform)
                let aspectRatio = abs(transformedSize.height / transformedSize.width)
                
                let calculatedHeight = UIScreen.main.bounds.width * aspectRatio
                let maxHeight = UIScreen.main.bounds.height * 0.5 // Adjust this value as needed
                
                DispatchQueue.main.async {
                    self.cellHeight = min(calculatedHeight, maxHeight)
                }
            } catch {
                print("Error calculating video height: \(error)")
            }
        }
    }
}
