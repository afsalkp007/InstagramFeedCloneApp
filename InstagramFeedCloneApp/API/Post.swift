//
//  Post.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation

public struct Post: Codable, Identifiable, Equatable {
    public let id: String
    public let images: [Image]?
    
    public init(id: String, images: [Image]?) {
        self.id = id
        self.images = images
    }
}

