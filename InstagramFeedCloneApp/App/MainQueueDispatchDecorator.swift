//
//  MainQueueDispatchDecorator.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

import Foundation

final class MainQueueDispatchDecorator<T> {
  private let decoratee: T
  
  init(decoratee: T) {
    self.decoratee = decoratee
  }
  
  func dispatch(_ completion: @escaping () -> Void) {
    guard Thread.isMainThread else {
      return DispatchQueue.main.async(execute: completion)
    }
    
    completion()
  }
}

extension MainQueueDispatchDecorator: DataLoader where T == DataLoader {
    func loadPosts(completion: @escaping (DataLoader.Result) -> Void) {
        decoratee.loadPosts { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: MediaDataLoader where T == MediaDataLoader {
    func loadMediaData(from url: URL, completion: @escaping (MediaDataLoader.Result) -> Void) {
        decoratee.loadMediaData(from: url) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
