//
//  Enums.swift
//  GenericAPIManager
//
//  Created by Ghoshit on 11/11/25.
//

import Foundation

enum ApiEnvironment: String {
    case production = "Production"
    case staging = "Staging"
    case development = "Development"
}

enum ApiHttpMethods: String {
    case GET = "GET"
    case POST = "POST"
}
