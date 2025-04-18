//
//  Post.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

struct Response: Codable {
    let success: Bool
    let status: Int
    let data: [Post]
}

struct Post: Codable, Identifiable {
    let id: String
    let images: [Image]?
}

struct Image: Codable, Identifiable {
    let id: String
    let type: TypeEnum
    let link: String
}

enum TypeEnum: String, Codable {
    case imageJPEG = "image/jpeg"
    case imagePNG = "image/png"
    case videoMp4 = "video/mp4"
}


