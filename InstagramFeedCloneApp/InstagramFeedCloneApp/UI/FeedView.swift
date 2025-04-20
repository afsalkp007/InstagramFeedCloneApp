//
//  ContentView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI
import InstagramFeedClone

struct FeedView: View {
    
    @Bindable var viewModel: FeedViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    if viewModel.showShimmer {
                        shimmerViews
                    } else {
                        postViews
                    }
                }
                .onAppear {
                    viewModel.fetchPosts()
                }
            }
            .refreshable {
                viewModel.fetchPosts()
            }
            .padding()
            .navigationTitle(viewModel.title)
            .alert(item: $viewModel.errorMessage) { errorWrapper in
                Alert(
                    title: Text(viewModel.error),
                    message: Text(errorWrapper.message),
                    dismissButton: .default(Text(viewModel.ok))
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
    
    private var postViews: some View {
        ForEach(viewModel.viewModels) { viewModel in
            PostView(viewModel: viewModel)
        }
    }
}
