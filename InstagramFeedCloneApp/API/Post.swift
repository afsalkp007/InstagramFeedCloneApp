//
//  Post.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation

struct Post: Codable, Identifiable {
    let id: String
    let images: [Image]?
}

