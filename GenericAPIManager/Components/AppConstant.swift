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
            return "https://apigenerator.dronahq.com/api/wiyElg3t/"
        case .development:
            return "https://apigenerator.dronahq.com/api/wiyElg3t/"
        case .staging:
            return "https://apigenerator.dronahq.com/api/wiyElg3t/"
        }
    }
}

struct AlertMessage: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

struct ApiURLS {
    static var getUsers: String {
        return "\(AppConstants.BASE_URL)users"
    }
    
    static var registerUsers: String {
        return "\(AppConstants.BASE_URL)users"
    }
}
