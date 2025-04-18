//
//  VideoManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import AVKit

final class FeedVideoViewModel {
    private let url: URL
    private var players: [URL: AVPlayer] = [:]
    
    init(url: URL) {
        self.url = url
    }

    func player() -> AVPlayer {
        if let player = players[url] {
            return player
        }
        let player = AVPlayer(url: url)
        players[url] = player
        return player
    }
    
    func play() {
        player().play()
    }
    
    func pause() {
        player().pause()
    }
    
    func playAll() {
        players.values.forEach { $0.play() }
    }

    func pauseAll() {
        players.values.forEach { $0.pause() }
    }
}
