//
//  RemoteDataItemMapper.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 19/04/2025.
//

import Foundation

final class RemoteFeedItemsMapper {
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.data
    }
}

struct Root: Codable {
    let data: [RemoteFeedItem]
}

struct RemoteFeedItem: Codable {
    public let id: String
    public let images: [Media]?
    
    init(id: String, images: [Media]?) {
        self.id = id
        self.images = images
    }
    
    var item: FeedItem? {
        guard let type = images?.first?.type, let mediaType = MediaType(rawValue: type), let url = URL(string: images?.first?.link ?? "") else { return nil }
        return FeedItem(id: id, type: mediaType, url: url)
    }
}

struct Media: Codable, Identifiable, Equatable {
    let id: String
    let type: String
    let link: String
    
    init(id: String, type: String, link: String) {
        self.id = id
        self.type = type
        self.link = link
    }
}
