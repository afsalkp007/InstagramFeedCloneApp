//
//  FeedViewModelAdapter.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 30/04/2025.
//

import Foundation

public protocol FeedPreloadable {
    func didPreloadMediaData(for feed: [FeedItem])
    func didCancelMediaLoad()
}

public class FeedViewModelPreloadingAdapter: FeedPreloadable {
    private var tasks: [URL: MediaDataLoaderTask] = [:]

    private let mediaLoader: MediaDataLoader
    
    public init(mediaLoader: MediaDataLoader) {
        self.mediaLoader = mediaLoader
    }
    
    public func didPreloadMediaData(for feed: [FeedItem]) {
        let mediaURLs = feed.compactMap(\.url)
        for url in mediaURLs {
            tasks[url] = mediaLoader.loadMediaData(from: url) { _ in }
        }
    }
    
    public func didCancelMediaLoad() {
        tasks.values.forEach { $0.cancel() }
        tasks.removeAll()
    }
}
