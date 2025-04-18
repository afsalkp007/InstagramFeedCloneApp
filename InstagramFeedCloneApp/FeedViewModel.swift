//
//  FeedViewModel.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation
import Combine

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let message: String
}

@Observable
class FeedViewModel {
    var posts: [Post] = []
    var errorMessage: ErrorWrapper?
    var isLoading: Bool = false

    private let networkManager: NetworkManager
    private var cancellables = Set<AnyCancellable>()
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchPosts() {
        isLoading = true
        networkManager.fetchPosts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = ErrorWrapper(message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] response in
                self?.posts = response.data
            })
            .store(in: &cancellables)
    }
}
