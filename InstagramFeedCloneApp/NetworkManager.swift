//
//  NetworkManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation
import Combine

class NetworkManager {
    func fetchPosts() -> AnyPublisher<Response, Error> {

        return URLSession.shared.dataTaskPublisher(for: postURLRequest)
            .map(\.data)
            .decode(type: Response.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    var postURLRequest: URLRequest {
        let urlString = Constants.API.baseURL.value + Constants.API.postsEndpoint(page: 0).value
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(Constants.API.accessToken.value)", forHTTPHeaderField: "Authorization")
        return request
    }
}
