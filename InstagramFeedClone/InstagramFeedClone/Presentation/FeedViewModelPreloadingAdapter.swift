//
//  FeedViewModelAdapter.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 30/04/2025.
//

import Foundation

public protocol FeedPreloadable {
    typealias EmptyCompletion = () -> Void
    
    func didPreloadMediaData(for feed: [FeedItem], completion: @escaping EmptyCompletion)
    func didCancelMediaLoad()
}

public class FeedViewModelPreloadingAdapter: FeedPreloadable {
    private var tasks: [URL: MediaDataLoaderTask] = [:]

    private let mediaLoader: MediaDataLoader
    
    public init(mediaLoader: MediaDataLoader) {
        self.mediaLoader = mediaLoader
    }
    
    public func didPreloadMediaData(for feed: [FeedItem], completion: @escaping FeedPreloadable.EmptyCompletion) {
        let dispatchGroup = DispatchGroup()

        let mediaURLs = feed.compactMap(\.url)
        for url in mediaURLs {
            dispatchGroup.enter()
                        
            tasks[url] = mediaLoader.loadMediaData(from: url) { result in
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    public func didCancelMediaLoad() {
        tasks.values.forEach { $0.cancel() }
        tasks.removeAll()
    }
}
