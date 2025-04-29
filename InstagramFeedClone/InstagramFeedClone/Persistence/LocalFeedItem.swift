//
//  LocalFeedItem.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 28/04/2025.
//

import Foundation

public struct LocalFeedItem: Codable, Equatable {
    public let id: String
    public let type: MediaType
    public let url: URL
    
    public init(id: String, type: MediaType, url: URL) {
        self.id = id
        self.type = type
        self.url = url
    }
}
