//
//  ContentView.swift
//  InstagramFeedCloneApp
//
//  Created by Mohamed Afsal on 17/04/2025.
//

import SwiftUI

struct FeedView: View {
    @Bindable private var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    if viewModel.isLoading && viewModel.posts.isEmpty {
                        ForEach(0..<5, id: \.self) { _ in
                            ShimmerView()
                                .frame(height: 300)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    } else {
                        ForEach(viewModel.posts) { post in
                            Group {
                                let dummyImage = Image(id: "", type: .imageJPEG, link: "https://i.imgur.com/foheRIC.jpg")
                                PostView(image: post.images?.first ?? dummyImage)
                            }
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchPosts()
                }
            }
            .padding()
            .navigationTitle("Instagram Feed")
            .alert(item: $viewModel.errorMessage) { errorWrapper in
                Alert(
                    title: Text("Error"),
                    message: Text(errorWrapper.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}


#Preview {
    FeedView()
}
