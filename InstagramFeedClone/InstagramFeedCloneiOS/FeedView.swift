//
//  ContentView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI
import InstagramFeedClone

public struct FeedView: View {
    
    @Bindable var viewModel: FeedPresentationAdapter
    private let preloader: FeedPreloadable
            
    public init(viewModel: FeedPresentationAdapter, delegate: FeedPreloadable) {
        self.viewModel = viewModel
        self.preloader = delegate
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    if viewModel.isLoading {
                        shimmerViews
                    } else {
                        itemViews
                    }
                }
                .onAppear {
                    viewModel.loadFeed()
                }
                .onDisappear {
                    preloader.didCancelMediaLoad()
                }
            }
            .refreshable {
                viewModel.loadFeed()
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
            
            switch viewModel.item.type {
            case .videoMp4:
                FeedVideoView(viewModel: viewModel)
                
            case .imageJPEG, .imagePNG, .imageGIF:
                FeedImageView(viewModel: viewModel)
            default:
                EmptyView()
            }
        }
    }
}
