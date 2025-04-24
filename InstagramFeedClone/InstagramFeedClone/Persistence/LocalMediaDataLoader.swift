//
//  LocalMediaDataLoader.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 24/04/2025.
//

import Foundation

public final class LocalMediaDataLoader {
    private let store: MediaDataStore
    
    public init(store: MediaDataStore) {
        self.store = store
    }
}

extension LocalMediaDataLoader: MediaDataLoader {
    public typealias LoadResult = MediaDataLoader.Result
    
    public enum LoadError: Swift.Error {
        case failed
        case notFound
    }
    
    private final class LoadImageDataTask: MediaDataLoaderTask {
        private var completion: ((MediaDataLoader.Result) -> Void)?
        
        init(completion: @escaping (MediaDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: MediaDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletion()
        }
        
        func preventFurtherCompletion() {
            completion = nil
        }
    }
    
    public func loadMediaData(from url: URL, completion: @escaping (MediaDataLoader.Result) -> Void) -> MediaDataLoaderTask {
        let task = LoadImageDataTask(completion: completion)
        store.retrieve(dataForURL: url) { [weak self] result in
            guard self != nil else { return }
            
            task.complete(with: result
                .mapError { _ in LoadError.failed }
                .flatMap { data in data.map { .success($0)} ?? .failure(LoadError.notFound) })
        }
        return task
    }
}

extension LocalMediaDataLoader: MediaDataCache {
    public typealias SaveResult = MediaDataCache.Result
    
    public enum SaveError: Swift.Error {
        case failed
    }
    
    public func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        store.insert(data, for: url) { [weak self] result in
            guard self != nil else { return }
            completion(result.mapError { _ in SaveError.failed })
        }
    }
}
