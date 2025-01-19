//
//  CompanyDetailsScreen.swift
//  DemoApp
//
//  Created by M C, Shilpashree on 19/01/25.
//

import SwiftUI

struct CompanyDetailsScreen: View {
    @ObservedObject var viewModel: CompanyDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                if let productDetails = viewModel.productDetails {
                    // Display product details
                    VStack(alignment: .leading, spacing: 0) {
                        // Product Image
                        if let imageUrl = URL(string: productDetails.image) {
                            AsyncImage(url: imageUrl) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                        .shadow(radius: 10)
                                        .padding(.bottom, 16)
                                case .failure:
                                    EmptyView()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        
                        // Product Name
                        Text(productDetails.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 8)
                        
                        // Product Type and Symbol
                        HStack {
                            Text(productDetails.type)
                                .font(.headline)
                            Spacer()
                            Text(productDetails.symbol)
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        
                        // Current Value and Percentage Change
                        HStack {
                            Text("Current Value: $\(productDetails.currentValue, specifier: "%.2f")")
                                .font(.title2)
                            Spacer()
                            Text("\(productDetails.percentageChange >= 0 ? "+" : "")\(productDetails.percentageChange, specifier: "%.2f")%")
                                .font(.title2)
                                .foregroundColor(productDetails.percentageChange >= 0 ? .green : .red)
                        }
                        
                        // Description
                        Text(productDetails.description)
                            .font(.body)
                            .padding(.vertical)
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                } else {
                    ProgressView(Constants.loadingText)
                        .onAppear {
                            viewModel.fetchProductDetails()
                        }
                }
            }
            .padding()
        }
    }
}

#Preview {
    CompanyDetailsScreen(viewModel: CompanyDetailsViewModel(productsUseCase: ProductInfo(ProductsDetails: ProductsDetailsTransaction(service: NetworkService(transcaction: APITransaction())))))
}
