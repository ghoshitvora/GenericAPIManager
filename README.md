# GenericAPIManager
A lightweight, concurrency-powered networking layer for Swift. Designed for scalability and testability with async/await, dependency injection, and built-in retry logic. Use it as a universal API layer for all your ViewModels.

## Features

✅ Unified API request builder using RequestTarget
✅ Supports all HTTP methods (GET, POST, PUT, DELETE)
✅ Configurable base URL and default headers
✅ Type-safe generic decoding
✅ Swift Concurrency & Sendable safe (Swift 6 ready)
✅ Works with Dependency Injection or EnvironmentObject
✅ Easily testable and mockable

## Usage

## GET Request example 

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

## License
This project is licensed under the MIT License - see the LICENSE file for details.
