//
//  APIManager.swift
//  GenericAPIManager
//
//  Created by Ghoshit on 11/11/25.
//

import Foundation

public protocol APIManagerProtocol {
    func sendRequest<T: Decodable>(_ target: APIRequestData) async throws -> T
}

// MARK: - DefaultNetworkService

public final class APIManager: APIManagerProtocol {
    
    // MARK: Properties
    private let cache: NetworkCache
    private let urlSession: URLSession
    
    public var maxRetryCount: Int = 2
    public var retryDelay: TimeInterval = 1.0
    
    // MARK: Init
    public init(cache: NetworkCache = NetworkCache(), urlSession: URLSession = .shared) {
        self.cache = cache
        self.urlSession = urlSession
    }
    
    // MARK: - Send Request
    
    public func sendRequest<T: Decodable>(_ target: APIRequestData) async throws -> T {
        let request = target.sendURLRequest()
        let cacheKey = request.url?.absoluteString ?? UUID().uuidString
        
        // 1️⃣ Try cache
        if let cached = await cache.get(for: cacheKey) {
            if let decoded = try? JSONDecoder().decode(T.self, from: cached) {
                return decoded
            }
        }
        
        // 2️⃣ Retry mechanism
        var attempt = 0
        var lastError: Error?
        
        while attempt <= maxRetryCount {
            do {
                let (data, response) = try await urlSession.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.invalidResponse
                }
                
                // Cache the response
                await cache.set(data, for: cacheKey)
                
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
                
            } catch {
                lastError = error
                attempt += 1
                if attempt > maxRetryCount {
                    throw NetworkError.maxRetryReached
                }
                try? await Task.sleep(nanoseconds: UInt64(retryDelay * 1_000_000_000))
            }
        }
        
        throw lastError ?? NetworkError.requestFailed(NSError(domain: "Unknown", code: -1))
    }
}

public extension APIRequestData {
    
    var headers: [String: String]? { nil }
    var parameters: [String: Any]? { nil }
    var multipartFormData: [(name: String, filename: String, data: Data)]? { nil }
    
    func sendURLRequest() -> URLRequest {
        
        guard var components = URLComponents(string: path) else {
            fatalError("❌ Invalid full URL: \(path)")
        }
        
        // Add query for GET
        if method == .GET, let parameters = parameters {
            components.queryItems = parameters.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        }
        
        guard let url = components.url else {
            fatalError("❌ Failed to create URL from components.")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let header = headers {
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Handle body (non-GET)
        if method != .GET, let parameters = parameters {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        // Handle multipart form data
        if let multipartFormData = multipartFormData {
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            var body = Data()
            for formData in multipartFormData {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(formData.name)\"; filename=\"\(formData.filename)\"\r\n")
                body.append("Content-Type: application/octet-stream\r\n\r\n")
                body.append(formData.data)
                body.append("\r\n")
            }
            body.append("--\(boundary)--\r\n")
            request.httpBody = body
        }
        
        return request
    }
}


// MARK: - NetworkCache

public actor NetworkCache {
    private var cache: [String: Data] = [:]
    public init() {}
    
    public func set(_ data: Data, for key: String) {
        cache[key] = data
    }
    
    public func get(for key: String) -> Data? {
        cache[key]
    }
    
    public func clear() {
        cache.removeAll()
    }
}

// MARK: - Data Helper

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

