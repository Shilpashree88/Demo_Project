//
//  ProductsUseCase.swift
//  DemoApp
//
//  Created by M C, Shilpashree on 19/01/25.
//

import Foundation
import Combine

protocol ProductsUseCase {
    func fetchCompanies() -> AnyPublisher<[CompanyDetails], Error>
    func fetchCompaniesFromLocal() -> AnyPublisher<[CompanyDetails], Error>
    func fetchProductDetails() -> AnyPublisher<ProductDetails, Error>
    func fetchProductDetailsFromLocal() -> AnyPublisher<ProductDetails, Error>
}

class ProductInfo: ProductsUseCase {
    private let ProductsDetails: ProductsDetailsTransaction
    
    init(ProductsDetails: ProductsDetailsTransaction) {
        self.ProductsDetails = ProductsDetails
    }
    
    func fetchCompanies() -> AnyPublisher<[CompanyDetails], Error> {
        return ProductsDetails.fetchAllCompanies()
    }
    
    func fetchCompaniesFromLocal() -> AnyPublisher<[CompanyDetails], Error> {
        return ProductsDetails.fetchAllCompaniesFromFile()
    }
    
    func fetchProductDetails() -> AnyPublisher<ProductDetails, Error> {
        return ProductsDetails.fetchProductDetails()
    }
    
    func fetchProductDetailsFromLocal() -> AnyPublisher<ProductDetails, Error> {
        return ProductsDetails.fetchProductDetailsFromFile()
    }
}
