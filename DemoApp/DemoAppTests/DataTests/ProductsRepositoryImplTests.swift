//
//  ProductsRepositoryImplTests.swift
//  DemoApp
//
//  Created by M C, Shilpashree on 19/01/25.
//

import XCTest
import Combine
@testable import DemoApp

class MockAPITransaction: APITransaction {
    var result: AnyPublisher<Data, Error>!
    
    override func request<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        result
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

class MockNetworkService: NetworkService {
    var companiesResult: AnyPublisher<[CompanyDetails], Error>!
    var productDetailsResult: AnyPublisher<ProductDetails, Error>!
    
    override func fetchCompanies() -> AnyPublisher<[CompanyDetails], Error> {
        companiesResult
    }
    
    override func fetchProductDetails() -> AnyPublisher<ProductDetails, Error> {
        productDetailsResult
    }
    override func fetchCompaniesFromFile(filename fileName: String) -> AnyPublisher<[CompanyDetails], Error> {
        companiesResult
    }
    
    override func fetchProductDetailsFromFile(filename fileName: String) -> AnyPublisher<ProductDetails, Error> {
        productDetailsResult
    }
}

final class ProductsRepositoryImplTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var mockNetworkService: MockNetworkService!
    var repository: ProductsRepositoryImpl!
    
    override func setUpWithError() throws {
        cancellables = []
        mockNetworkService = MockNetworkService(transcaction: MockAPITransaction())
        repository = ProductsRepositoryImpl(service: mockNetworkService)
    }
    
    override func tearDownWithError() throws {
        cancellables = nil
        mockNetworkService = nil
        repository = nil
    }
    
    func testFetchCompanies_LocalJson_Success() {
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
        let expectation = self.expectation(description: "Fetching companies from local JSON")
        var fetchedCompanies: [CompanyDetails]?
        var fetchedError: Error?
        
        repository.fetchAllCompaniesFromFile()
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
    
    func testFetchCompanies_LocalJson_Failure() {
        // Given
        let error = NSError(domain: "", code: -1, userInfo: nil)
        mockNetworkService.companiesResult = Fail<[CompanyDetails], Error>(error: error)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Fetching companies from local JSON")
        var fetchedCompanies: [CompanyDetails]?
        var fetchedError: Error?
        
        repository.fetchAllCompaniesFromFile()
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
    
    func testFetchProductDetails_LocalJson_Success() {
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
        let expectation = self.expectation(description: "Fetching product details from local JSON")
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
    
    func testFetchProductDetails_LocalJson_Failure() {
        // Given
        let error = NSError(domain: "", code: -1, userInfo: nil)
        mockNetworkService.productDetailsResult = Fail<ProductDetails, Error>(error: error)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Fetching product details from local JSON")
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
    
    func testFetchCompanies_API_Success() {
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
        let expectation = self.expectation(description: "Fetching companies from API")
        var fetchedCompanies: [CompanyDetails]?
        var fetchedError: Error?
        
        mockNetworkService.fetchCompanies()
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
    
    func testFetchCompanies_API_Failure() {
        // Given
        let error = NSError(domain: "", code: -1, userInfo: nil)
        mockNetworkService.companiesResult = Fail<[CompanyDetails], Error>(error: error)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Fetching companies from API")
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
    
    func testFetchProductDetails_API_Success() {
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
        let expectation = self.expectation(description: "Fetching product details from API")
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
    
    func testFetchProductDetails_API_Failure() {
        // Given
        let error = NSError(domain: "", code: -1, userInfo: nil)
        mockNetworkService.productDetailsResult = Fail<ProductDetails, Error>(error: error)
            .eraseToAnyPublisher()
        
        // When
        let expectation = self.expectation(description: "Fetching product details from API")
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

