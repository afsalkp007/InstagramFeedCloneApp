//
//  FeedLoaderStub.swift
//  InstagramFeedCloneAppTests
//
//  Created by Mohamed Afsal on 03/05/2025.
//

import InstagramFeedClone

class FeedLoaderStub: FeedLoader {
    let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func loadFeed(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
