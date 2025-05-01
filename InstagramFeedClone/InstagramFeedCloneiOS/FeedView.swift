//
//  ContentView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI
import InstagramFeedClone

public protocol FeedViewDelegate {
    func didRequestsFeed()
}

public struct FeedView: View {
    
    @Bindable var viewModel: FeedViewModel
    private let preloader: FeedPreloadable
        
    private var loader: FeedViewDelegate
    
    public init(viewModel: FeedViewModel, delegate: FeedPreloadable, loader: FeedViewDelegate) {
        self.viewModel = viewModel
        self.preloader = delegate
        self.loader = loader
    }
    
    public var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    if viewModel.showShimmer {
                        shimmerViews
                    } else {
                        itemViews
                    }
                }
                .onAppear {
                    loader.didRequestsFeed()
                }
                .onDisappear {
                    preloader.didCancelMediaLoad()
                }
            }
            .refreshable {
                loader.didRequestsFeed()
            }
            .padding()
            .navigationTitle(Localized.title.value)
            .alert(item: $viewModel.errorMessage) { errorWrapper in
                Alert(
                    title: Text(Localized.error.value),
                    message: Text(errorWrapper.message),
                    dismissButton: .default(Text(Localized.ok.value))
                )
            }
        }
    }
    
    private var shimmerViews: some View {
        ForEach(0..<5, id: \.self) { _ in
            ShimmerView()
                .frame(height: 300)
                .cornerRadius(10)
        }
    }
    
    private var itemViews: some View {
        ForEach(viewModel.viewModels) { viewModel in
            ItemView(viewModel: viewModel)
        }
    }
}
