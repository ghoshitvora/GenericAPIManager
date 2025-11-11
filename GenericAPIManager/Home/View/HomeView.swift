//
//  HomeView.swift
//  GenericAPIManager
//
//  Created by Ghoshit on 11/11/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading Products...")
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text("❌ \(error)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task { await viewModel.fetchProducts() }
                        }
                        .padding(.top)
                    }
                } else {
                    List(viewModel.homeData, id: \.id) { product in
                        VStack(alignment: .leading) {
                            Text(product.name ?? "ABC")
                        }
                    }
                }
            }
            .navigationTitle("Products")
        }
        .task {
            await viewModel.fetchProducts()
        }
    }
}

#Preview {
    HomeView()
}
