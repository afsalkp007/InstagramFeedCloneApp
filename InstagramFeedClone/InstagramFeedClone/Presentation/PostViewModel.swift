//
//  PostViewModel.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation

public class PostViewModel: Identifiable {
    public let id = UUID()
    public let media: Media
    
    private let loader: MediaDataLoader
    private let cacheManager: CacheService
        
    init(media: Media, loader: MediaDataLoader, cacheManager: CacheService) {
        self.media = media
        self.loader = loader
        self.cacheManager = cacheManager
    }
}

extension PostViewModel {
    public typealias URLCompletion = (Result<URL, Error>) -> Void

    private func fetchVideoData(completion: @escaping URLCompletion) {
        loader.loadMediaData(from: media.url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(data):
                self.cacheManager.cacheData(data, for: media.url)
                self.writeDataToTempURL(data: data, url: media.url, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    public func loadVideo(completion: @escaping URLCompletion) {
        let url = self.media.url
        cacheManager.getCachedData(for: url) { [weak self] result in
            switch result {
            case let .success(data):
                self?.writeDataToTempURL(data: data, url: url, completion: completion)
            case .failure:
                self?.fetchVideoData(completion: completion)
            }
        }
    }
    
    private func writeDataToTempURL(data: Data, url: URL, completion: @escaping URLCompletion) {
        do {
            try data.write(to: tempURL)
            completion(.success(tempURL))
        } catch {
            completion(.failure(error))
        }
    }
    
    private var tempURL: URL {
        return FileManager.default.temporaryDirectory.appendingPathComponent(media.url.lastPathComponent)
    }
}
 
extension PostViewModel {
    public typealias DataCompletion = (Result<Data, Error>) -> Void

    private func fetchImageData(completion: @escaping DataCompletion) {
        loader.loadMediaData(from: media.url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(data):
                self.cacheManager.cacheData(data, for: self.media.url)
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    public func loadImage(completion: @escaping DataCompletion) {
        cacheManager.getCachedData(for: media.url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(data):
                completion(.success(data))
            case .failure:
                fetchImageData(completion: completion)
            }
        }
    }
}
