//
//  RemoteDataItemMapper.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation

public final class RemoteDataItemMapper {
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Post] {
        guard response.isOK else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.data
    }
}

struct Root: Codable {
    let success: Bool
    let status: Int
    let data: [Post]
}

public struct Media: Codable, Identifiable, Equatable {
    public let id: String
    public let type: MediaType
    public let link: String
    
    var url: URL {
        URL(string: link)!
    }
}

public enum MediaType: String, Codable {
    case imageJPEG = "image/jpeg"
    case imagePNG = "image/png"
    case imageGIF = "image/gif"
    case videoMp4 = "video/mp4"
}

