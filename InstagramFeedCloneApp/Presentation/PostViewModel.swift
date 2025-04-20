//
//  PostViewModel.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation
import AVKit

class PostViewModel: Identifiable {
    let id = UUID()
    let media: Media
    
    private let loader: MediaDataLoader
    private let cacheManager: CacheManager
        
    typealias URLCompletion = (Result<URL, Error>) -> Void
    typealias DataCompletion = (Result<Data, Error>) -> Void

    init(media: Media, loader: MediaDataLoader) {
        self.media = media
        self.loader = loader
        self.cacheManager = CacheManager()
    }
    
    // MARK: - Video Loading

    private func fetchVideoData(completion: @escaping URLCompletion) {
        loader.loadMediaData(from: media.url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(data):
                self.cacheManager.cacheData(data, for: media.url)
                self.writeDataToTempURL(data: data, url: media.url, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func loadVideo(completion: @escaping URLCompletion) {
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
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
        do {
            try data.write(to: tempURL)
            completion(.success(tempURL))
        } catch {
            completion(.failure(error))
        }
    }
                 
    // MARK: - Image Loading
    
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
    
    func loadImage(completion: @escaping DataCompletion) {
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
