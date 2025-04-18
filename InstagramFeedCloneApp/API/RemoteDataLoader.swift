//
//  NetworkManager.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation

final class RemoteDataLoader: DataLoader {
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func loadPosts(completion: @escaping (DataLoader.Result) -> Void) {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(Constants.accessToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "NetworkManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(decodedResponse.data))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
