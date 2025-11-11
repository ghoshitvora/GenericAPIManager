//
//  APIClient.swift
//  GenericAPIManager
//
//  Created by Ghoshit on 11/11/25.
//

import Foundation

// MARK: - HTTPMethod

public enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

// MARK: - NetworkConfiguration

public struct APIConfiguration {
    public let baseURL: String
    public let defaultHeaders: [String: String]
    
    public init(baseURL: String, defaultHeaders: [String: String] = [:]) {
        self.baseURL = baseURL
        self.defaultHeaders = defaultHeaders
    }
}

// MARK: - RequestTarget

public protocol APIRequestData {
    /// Only endpoint path (e.g. "/users")
    var path: String { get }
    
    /// HTTP method for this API
    var method: HTTPMethod { get }
    
    /// Optional override for headers (merged with global headers)
    var headers: [String: String]? { get }
    
    /// Optional parameters (query/body)
    var parameters: [String: Any]? { get }
    
    /// Optional multipart form data
    var multipartFormData: [(name: String, filename: String, data: Data)]? { get }
}

// MARK: - Network Error

public enum NetworkError: Error, LocalizedError {
    case invalidResponse
    case requestFailed(Error)
    case decodingFailed(Error)
    case maxRetryReached
    
    public var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Invalid or unexpected response"
        case .requestFailed(let error): return "Request failed: \(error.localizedDescription)"
        case .decodingFailed(let error): return "Decoding failed: \(error.localizedDescription)"
        case .maxRetryReached: return "Maximum retry attempts reached"
        }
    }
}
