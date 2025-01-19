//
//  ProductUseCaseTests.swift
//  DemoAppTests
//
//  Created by M C, Shilpashree on 19/01/25.
//

import XCTest
import Combine
@testable import DemoApp

final class ProductUseCaseTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var mockNetworkService: MockNetworkService!
    var repository: ProductsRepositoryImpl!
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cancellables = []
        mockNetworkService = MockNetworkService(transcaction: MockAPITransaction())
        repository = ProductsRepositoryImpl(service: mockNetworkService)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        cancellables = nil
        mockNetworkService = nil
        repository = nil
        super.tearDown()
    }
    
    func testFetchCompanies_Success() {
        // Given
        let companies = [
            CompanyDetails(id: "1", name: "Advanced Millenium Technologies.", logo: "https://example.com/logos/tech_innovators.png", products: [
                Product(id: "1", name: "Apple Inc.", type: "Stock", currentValue: 145.32, percentageChange: 1.24, symbol: "AAPL", timestamp: "2024-06-19T10:00:00Z", image: "https://example.com/images/apple.png")
            ])
        ]
        mockNetworkService.companiesResult = Just(companies)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Fetching companies")
        var fetchedCompanies: [CompanyDetails]?
        var fetchedError: Error?
        
        repository.fetchAllCompanies()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    fetchedError = error
                }
                expectation.fulfill()
            }, receiveValue: { companies in
                fetchedCompanies = companies
            })
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(fetchedCompanies)
        XCTAssertEqual(fetchedCompanies?.count, companies.count)
        XCTAssertNil(fetchedError)
    }
    
    
    func testFetchCompanies_Failure() {
        // Given
        let error = NSError(domain: "", code: -1, userInfo: nil)
        mockNetworkService.companiesResult = Fail<[CompanyDetails], Error>(error: error)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Fetching companies")
        var fetchedCompanies: [CompanyDetails]?
        var fetchedError: Error?
        
        repository.fetchAllCompanies()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    fetchedError = error
                }
                expectation.fulfill()
            }, receiveValue: { companies in
                fetchedCompanies = companies
            })
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNil(fetchedCompanies)
        XCTAssertNotNil(fetchedError)
    }
    
    func testFetchProductDetails_Success() {
        // Given
        let productDetails = ProductDetails(
            id: "1",
            name: "Microsoft.",
            type: "PUBLIC",
            symbol: "MSFT",
            currentValue: 145.32,
            percentageChange: 1.24,
            description: "Microsoft Corporation is an American multinational technology conglomerate headquartered in Redmond, Washington.[2] Founded in 1975.",
            timestamp: "2024-06-19T10:00:00Z",
            image: "https://picsum.photos/100/100?pocoso",
            historicalData: [
                HistoricalData(date: "2025-18-01", value: 101.1),
                HistoricalData(date: "2025-06-01", value: 143.85)
            ]
        )
        mockNetworkService.productDetailsResult = Just(productDetails)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Fetching product details")
        var fetchedProductDetails: ProductDetails?
        var fetchedError: Error?
        
        repository.fetchProductDetails()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    fetchedError = error
                }
                expectation.fulfill()
            }, receiveValue: { details in
                fetchedProductDetails = details
            })
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(fetchedProductDetails)
        XCTAssertEqual(fetchedProductDetails?.id, productDetails.id)
        XCTAssertNil(fetchedError)
    }
    
    func testFetchProductDetails_Failure() {
        // Given
        let error = NSError(domain: "", code: -1, userInfo: nil)
        mockNetworkService.productDetailsResult = Fail<ProductDetails, Error>(error: error)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Fetching product details")
        var fetchedProductDetails: ProductDetails?
        var fetchedError: Error?
        
        repository.fetchProductDetails()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    fetchedError = error
                }
                expectation.fulfill()
            }, receiveValue: { details in
                fetchedProductDetails = details
            })
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNil(fetchedProductDetails)
        XCTAssertNotNil(fetchedError)
    }
    
}
