//
//  FeedItem.swift
//  InstagramFeedClone
//
//  Created by Mohamed Afsal on 28/04/2025.
//

import Foundation

public struct FeedItem: Equatable {
    public let type: MediaType
    public let url: URL
    
    public init(type: MediaType, url: URL) {
        self.type = type
        self.url = url
    }
}

public enum MediaType: String, Codable {
    case imageJPEG = "image/jpeg"
    case imagePNG = "image/png"
    case imageGIF = "image/gif"
    case videoMp4 = "video/mp4"
    case unknown = "unknown"
}

