//
//  FeedVideoViewAdapter.swift
//  InstagramFeedCloneiOS
//
//  Created by Mohamed Afsal on 30/04/2025.
//

import AVKit

@Observable
public final class FeedVideoViewModel {
    public var player: AVPlayer?
    public var cellHeight: CGFloat = 300
    
    private let viewModel: MediaViewModel
    
    public init(viewModel: MediaViewModel) {
        self.viewModel = viewModel
    }
    
    private func tempURL() -> URL {
        return FileManager.default
            .temporaryDirectory
            .appendingPathComponent(viewModel.item.url.lastPathComponent)
    }
}
 
extension FeedVideoViewModel {
    public func didRequestVideo() {
        viewModel.loadMedia { [weak self] result in
            guard let self = self, let data = try? result.get() else { return }
            
            try? data.write(to: tempURL())
            self.player = AVPlayer(url: tempURL())
            try? self.calculateHeight()
        }
    }
    
    public func didCancelVideoLoad() {
        viewModel.cancelMediaLoad()
    }
}
    
extension FeedVideoViewModel {
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
