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
    
    private var tasks: [URL: MediaDataLoaderTask] = [:]
        
    init(media: Media, loader: MediaDataLoader) {
        self.media = media
        self.loader = loader
    }
    
    public func cancelMediaLoad() {
        tasks.values.forEach { $0.cancel() }
        tasks.removeAll()
    }
    
    deinit {
        cancelMediaLoad()
    }
}
 
extension PostViewModel {
    public typealias DataCompletion = (Result<Data, Error>) -> Void
    
    public func loadMedia(completion: @escaping DataCompletion) {
        tasks[media.url] = loader.loadMediaData(from: media.url) { result in
            switch result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
