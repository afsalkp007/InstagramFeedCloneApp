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
    private let saver: DataSaver
    

    init(loader: DataLoader, saver: DataSaver) {
        self.loader = loader
        self.saver = saver
    }
    
    func fetchPosts() {
        isLoading = true
        
        loader.loadPosts { [weak self] result in
            guard let self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let posts):
                DispatchQueue.main.async {
                    self.posts = posts
                }
                self.saver.savePosts(posts)
            case .failure(let error):
                self.errorMessage = ErrorWrapper(message: error.localizedDescription)
            }
        }
    }
}
