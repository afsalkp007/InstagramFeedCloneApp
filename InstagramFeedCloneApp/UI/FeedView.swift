//
//  ContentView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI

struct FeedView: View {
    
    @Bindable var viewModel: FeedViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    if viewModel.showShimmer {
                        ForEach(0..<5, id: \.self) { _ in
                            ShimmerView()
                                .frame(height: 300)
                                .cornerRadius(10)
                        }
                    } else {
                        ForEach(viewModel.posts) { post in
                            Group {
                                PostView(image: post.images?.first ?? placeHolder)
                            }
                        }
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
            .navigationTitle("Instagram Sample Feed")
            .alert(item: $viewModel.errorMessage) { errorWrapper in
                Alert(
                    title: Text("Error"),
                    message: Text(errorWrapper.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private var placeHolder: Image {
        Image(
            id: "dfsd3423",
            type: .imageJPEG,
            link: "https://i.imgur.com/foheRIC.jpg"
        )
    }
}

