//
//  FeedViewModel.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let message: String
}

@Observable
class FeedViewModel {
    var posts: [Post] = []
    var errorMessage: ErrorWrapper?
    var isLoading: Bool = false
    
    private let loader: DataLoader

    init(loader: DataLoader) {
        self.loader = loader
    }
    
    func fetchPosts() {
        isLoading = true
        
        loader.loadPosts { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let posts):
                self.posts = posts
            case .failure(let error):
                self.errorMessage = ErrorWrapper(message: error.localizedDescription)
            }
        }
    }
    
    var showShimmer: Bool {
        isLoading && posts.isEmpty
    }
}
