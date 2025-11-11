//
//  AppConstant.swift
//  GenericAPIManager
//
//  Created by Ghoshit on 11/11/25.
//

import Foundation

struct AppConstants {
    
    private static var environment: ApiEnvironment = .production
    
    static func setupAPI(env: ApiEnvironment) {
        environment = env
    }
    
    static var BASE_URL: String {
        switch environment {
        case .production:
            return "https://api.restful-api.dev/"
        case .development:
            return "https://api.restful-api.dev/"
        case .staging:
            return "https://api.restful-api.dev/"
        }
    }
}

struct ApiURLS {
    static var objectData: String {
        return "\(AppConstants.BASE_URL)objects"
    }
}
