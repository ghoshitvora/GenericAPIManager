//
//  HomeModel.swift
//  GenericAPIManager
//
//  Created by Ghoshit on 11/11/25.
//

import Foundation

struct HomeModel: Codable {
    var id: String?
    var name: String?
    var data: ProductData?
}

struct ProductData: Codable {
    let color: String?
    let capacity: String?
    let price: Double?
    let generation: String?
    let year: Int?
    let cpuModel: String?
    let hardDiskSize: String?
    let caseSize: String?
    let strapColour: String?
    let description: String?
    let screenSize: Double?

    enum CodingKeys: String, CodingKey {
        case color, capacity, price, generation, year, description, screenSize = "Screen size"
        case cpuModel = "CPU model", hardDiskSize = "Hard disk size"
        case caseSize = "Case Size", strapColour = "Strap Colour"
    }
}
