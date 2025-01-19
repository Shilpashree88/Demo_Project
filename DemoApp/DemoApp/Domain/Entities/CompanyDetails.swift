//
//  CompanyDetails.swift
//  DemoApp
//
//  Created by M C, Shilpashree on 19/01/25.
//

import Foundation


struct CompanyDetails: Identifiable, Codable {
    let id: String
    let name: String
    let logo: String
    let products: [Product]
}

struct Product: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
    let currentValue: Double
    let percentageChange: Double
    let symbol: String
    let timestamp: String
    let image: String
}

struct CompaniesResponse: Codable {
    let companies: [CompanyDetails]
}
