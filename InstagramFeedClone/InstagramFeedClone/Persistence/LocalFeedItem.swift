//
//  LocalFeedItem.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 28/04/2025.
//

import Foundation

public struct LocalFeedItem: Codable, Equatable {
    public let type: MediaType
    public let url: URL
    
    public init(type: MediaType, url: URL) {
        self.type = type
        self.url = url
    }
}
