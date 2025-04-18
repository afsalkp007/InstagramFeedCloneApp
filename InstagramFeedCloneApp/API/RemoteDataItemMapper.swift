//
//  RemoteDataItemMapper.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation

final class RemoteDataItemMapper {
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Post] {
        guard response.statusCode == 200 else {
            throw RemoteDataLoader.Error.invalidData
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

struct Image: Codable, Identifiable {
    let id: String
    let type: TypeEnum
    let link: String
    
    var url: URL {
        URL(string: link)!
    }
}

enum TypeEnum: String, Codable {
    case imageJPEG = "image/jpeg"
    case imagePNG = "image/png"
    case imageGIF = "image/gif"
    case videoMp4 = "video/mp4"
}

