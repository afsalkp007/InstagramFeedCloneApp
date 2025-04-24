//
//  UserDefaultsFeedStore+MediaDataStore.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 24/04/2025.
//

import Foundation

public final class FileManagerMediaStore: MediaDataStore {
    private let fileManager: FileManager
    private let diskCacheDirectory: URL
    private let queue: DispatchQueue
    private let cache: NSCache<NSURL, NSData>
    
    public init(fileManager: FileManager = .default, cacheDirectory: URL? = nil) {
        self.fileManager = fileManager
        self.queue = DispatchQueue(label: Constants.Cache.queue.value, attributes: .concurrent)
        self.cache = NSCache<NSURL, NSData>()
        
        let defaultCacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.diskCacheDirectory = cacheDirectory ?? defaultCacheDirectory.appendingPathComponent(Constants.Cache.mediaCache.value)
        try? fileManager.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true)
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
    
    public func retrieve(dataForURL url: URL, completion: @escaping (MediaDataStore.RetrievalResult) -> Void) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            
            if let cachedData = self.cache.object(forKey: url as NSURL) {
                completion(.success(cachedData as Data))
            } else {
                completion(self.map(url))
            }
        }
    }
    
    private func map(_ url: URL) -> MediaDataStore.RetrievalResult {
        do {
            let data = try Data(contentsOf: self.diskCachePath(for: url))
            cache.setObject(data as NSData, forKey: url as NSURL)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    private func diskCachePath(for url: URL) -> URL {
        return diskCacheDirectory.appendingPathComponent(url.lastPathComponent)
    }
    
    public func insert(_ data: Data, for url: URL, completion: @escaping (MediaDataStore.InsertionResult) -> Void) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            
            self.cache.setObject(data as NSData, forKey: url as NSURL)
            try? data.write(to: self.diskCachePath(for: url))
        }
    }
}
