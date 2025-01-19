//
//  CompanyDetailsViewModel.swift
//  DemoApp
//
//  Created by M C, Shilpashree on 19/01/25.
//

import Foundation
import Combine

class CompanyDetailsViewModel: ObservableObject {
    
    private let productsUseCase: ProductsUseCase
    @Published var productDetails:ProductDetails?
    private var cancellables = Set<AnyCancellable>()
    
    init(productsUseCase: ProductsUseCase) {
        self.productsUseCase = productsUseCase
    }
    
    func fetchProductDetails() {
        productsUseCase.fetchProductDetails()
            .sink(receiveCompletion: { completion in
                self.fetchProductDetailsFromLocal()
            }, receiveValue: { productDetails in
                self.productDetails = productDetails
            })
            .store(in: &cancellables)
    }
    
    func fetchProductDetailsFromLocal() {
        productsUseCase.fetchProductDetailsFromLocal()
            .sink(receiveCompletion: { completion in
            }, receiveValue: { productDetails in
                self.productDetails = productDetails
            })
            .store(in: &cancellables)
    }
}
