//
// NetworkService.swift
//  DemoApp
//
//  Created by M C, Shilpashree on 19/01/25.
//

import Foundation
import Combine

class NetworkService {
    
    private let transcaction: APITransaction
    
    init(transcaction: APITransaction) {
        self.transcaction = transcaction
    }
    let requestUrl = URL(string: "http://127.0.0.1:3001/allproducts")
    
    func fetchCompanies() -> AnyPublisher<[CompanyDetails], Error> {
        guard let url = requestUrl else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return transcaction.request(url)
            .map { (response: CompaniesResponse) in
                response.companies
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchProductDetails() -> AnyPublisher<ProductDetails, Error> {
        guard let url = requestUrl else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return transcaction.request(url)
            .map { (response: ProductDetailsResponse) in
                response.productDetails
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    // fetch from Local JSON fils
    
    func fetchCompaniesFromFile(filename: String) -> AnyPublisher<[CompanyDetails], Error> {
        Future { promise in
            DispatchQueue.global(qos: .background).async {
                guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
                    return promise(.failure(URLError(.fileDoesNotExist)))
                }
                
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let companiesResponse = try decoder.decode(CompaniesResponse.self, from: data)
                    DispatchQueue.main.async {
                        promise(.success(companiesResponse.companies))
                    }
                } catch {
                    DispatchQueue.main.async {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchProductDetailsFromFile(filename: String) -> AnyPublisher<ProductDetails, Error> {
        Future { promise in
            DispatchQueue.global(qos: .background).async {
                guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
                    return promise(.failure(URLError(.fileDoesNotExist)))
                }
                
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let detailsResponse = try decoder.decode(ProductDetailsResponse.self, from: data)
                    DispatchQueue.main.async {
                        promise(.success(detailsResponse.productDetails))
                    }
                } catch {
                    DispatchQueue.main.async {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
