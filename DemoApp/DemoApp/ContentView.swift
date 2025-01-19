//
//  ContentView.swift
//  DemoApp
//
//  Created by M C, Shilpashree on 19/01/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HomeScreen(viewModel: HomeScreenModel(productsUseCase: ProductInfo(ProductsDetails: ProductsRepositoryImpl(service: NetworkService(transcaction: APITransaction())))))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
