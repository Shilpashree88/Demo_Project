//
//  HomeScreen.swift
//  DemoApp
//
//  Created by M C, Shilpashree on 19/01/25.
//

import SwiftUI

struct HomeScreen: View {
    @ObservedObject var viewModel: HomeScreenModel
    var body: some View {
        NavigationView {
            List(self.viewModel.companies) { company in
                NavigationLink(destination: CompanyDetailsScreen(viewModel: CompanyDetailsViewModel(productsUseCase: ProductInfo(ProductsDetails: ProductsRepositoryImpl(service: NetworkService(transcaction: APITransaction())))))) {
                    VStack(alignment: .leading) {
                        Text(company.name)
                            .font(.headline)
                    }
                }
            }
            .onAppear {
                viewModel.fetchCompanies()
            }
            .navigationTitle(self.viewModel.screenTitle)
        }
    }
    
}
#Preview {
    HomeScreen(viewModel: HomeScreenModel(productsUseCase: ProductInfo(ProductsDetails: ProductsRepositoryImpl(service: NetworkService(transcaction: APITransaction())))))
}

