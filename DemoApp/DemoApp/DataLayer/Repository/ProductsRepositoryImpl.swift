//
//  ProductsRepositoryImpl.swift
//  DemoApp
//
//  Created by M C, Shilpashree on 19/01/25.
//

import Foundation
import Combine

protocol ProductsRepository {
    func fetchAllCompanies() -> AnyPublisher<[CompanyDetails], Error>
    func fetchProductDetails() -> AnyPublisher<ProductDetails, Error>
}

class ProductsRepositoryImpl: ProductsRepository {
    
    private let service : NetworkService
    
    init(service: NetworkService) {
        self.service = service
    }
    
    func fetchAllCompanies() -> AnyPublisher<[CompanyDetails], Error> {
        return service.fetchCompanies()
    }
    
    func fetchProductDetails() -> AnyPublisher<ProductDetails, Error> {
        return service.fetchProductDetails()
    }
    
    func fetchAllCompaniesFromFile() -> AnyPublisher<[CompanyDetails], Error> {
        return service.fetchCompaniesFromFile(filename: "companies")
    }
    
    func fetchProductDetailsFromFile() -> AnyPublisher<ProductDetails, Error> {
        return service.fetchProductDetailsFromFile(filename: "productDetails")
    }
}
