//
//  DataSaver.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 18/04/2025.
//

protocol DataSaver {
    typealias Result = Swift.Result<Void, Error>
    
    func savePosts(_ posts: [Post], completion: @escaping (Result) -> Void)
}
