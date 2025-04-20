//
//  DataLoader.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

public protocol DataLoader {
    typealias Result = Swift.Result<[Post], Error>
    
    func loadPosts(completion: @escaping (Result) -> Void)
}
