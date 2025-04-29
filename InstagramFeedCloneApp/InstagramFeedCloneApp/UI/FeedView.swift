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
                        itemViews
                    }
                }
                .onAppear {
                    viewModel.fetchFeed()
                }
                .onDisappear {
                    viewModel.cancelMediaLoad()
                }
            }
            .refreshable {
                viewModel.fetchFeed()
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
    
    private var itemViews: some View {
        ForEach(viewModel.viewModels) { viewModel in
            ItemView(viewModel: viewModel)
        }
    }
}
