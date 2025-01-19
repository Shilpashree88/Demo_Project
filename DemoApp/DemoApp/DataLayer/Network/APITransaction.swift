//
//  APITransaction.swift
//  DemoApp
//
//  Created by M C, Shilpashree on 19/01/25.
//

import Foundation
import Combine

enum NetworkError: Error {
    case decodingError(DecodingError.Context)
    case urlError(URLError)
}

class APITransaction {
    func request<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                
                return data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
