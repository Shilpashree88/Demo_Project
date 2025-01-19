//
//  HomeScreenModel.swift
//  DemoApp
//
//  Created by M C, Shilpashree on 19/01/25.
//

import Foundation
import Combine

class HomeScreenModel: ObservableObject {
    
    private let getProductsUseCase: ProductsUseCase
    @Published var companies: [CompanyDetails] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(productsUseCase: ProductsUseCase) {
        self.getProductsUseCase = productsUseCase
    }
    
    func fetchCompanies() {
        getProductsUseCase.fetchCompanies()
            .sink(receiveCompletion: { completion in
                self.fetchCompaniesFromLocal()
            }, receiveValue: { companies in
                self.companies = companies
            })
            .store(in: &cancellables)
    }
    
    func fetchCompaniesFromLocal() {
        getProductsUseCase.fetchCompaniesFromLocal()
            .sink(receiveCompletion: { completion in
            }, receiveValue: { companies in
                self.companies = companies
            })
            .store(in: &cancellables)
    }
    
    var screenTitle: String {
        return Constants.screenTitle
    }
}
