//
//  ItemViewModel.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation

public class MediaViewModel: Identifiable {
    public let id = UUID()
    public let item: FeedItem
    private let loader: MediaDataLoader
    
    private var tasks: [URL: MediaDataLoaderTask] = [:]
    public typealias DataCompletion = (Result<Data, Error>) -> Void
        
    init(item: FeedItem, loader: MediaDataLoader) {
        self.item = item
        self.loader = loader
    }
    
    public func cancelMediaLoad() {
        tasks.values.forEach { $0.cancel() }
        tasks.removeAll()
    }
    
    deinit {
        cancelMediaLoad()
    }
        
    public func loadMedia(completion: @escaping DataCompletion) {
        tasks[item.url] = loader.loadMediaData(from: item.url) { result in
            
            completion(result
                .mapError { return $0 }
                .flatMap { .success($0) })
        }
    }
}
