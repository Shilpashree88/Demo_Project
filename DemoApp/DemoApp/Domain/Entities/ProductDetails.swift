//
//  ProductDetails.swift
//  DemoApp
//
//  Created by M C, Shilpashree on 19/01/25.
//

import Foundation

struct ProductDetails: Codable {
    let id: String
    let name: String
    let type: String
    let symbol: String
    let currentValue: Double
    let percentageChange: Double
    let description: String
    let timestamp: String
    let image: String
    let historicalData: [HistoricalData]
}

struct HistoricalData: Codable {
    let date: String
    let value: Double
}

struct ProductDetailsResponse: Codable {
    let productDetails: ProductDetails
}
