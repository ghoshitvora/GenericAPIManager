//
//  HomeViewModel.swift
//  GenericAPIManager
//
//  Created by Ghoshit on 11/11/25.
//

import SwiftUI
import Combine

struct getUsersAPI: APIRequestData {
    var path: String { ApiURLS.objectData }
    var method: HTTPMethod { .GET }
}

class HomeViewModel: ObservableObject {
    
    @Published var homeData: [HomeModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let api: APIManagerProtocol
    
    // MARK: - Init Method(s)
    
    init(api: APIManagerProtocol = APIManager()) {
        self.api = api
    }
    
    // MARK: - Api Method(s)
    
    func fetchProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let homeData: [HomeModel] = try await api.sendRequest(getUsersAPI())
            self.homeData = homeData
        } catch {
            if let networkError = error as? NetworkError {
                errorMessage = networkError.localizedDescription
            } else {
                errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
    }
    
}
