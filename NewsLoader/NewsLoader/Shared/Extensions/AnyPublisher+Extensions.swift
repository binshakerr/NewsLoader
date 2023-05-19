//
//  AnyPublisher+Extensions.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 18/05/2023.
//

import Foundation
import Combine

extension AnyPublisher {
    
    //create shorthand version for returning observable from non-reactive function with async await support
    static func createAsync<T>(_ function: @escaping () async throws -> T) -> AnyPublisher<T, Error> {
        Future<T, Error> { promise in
            Task {
                do {
                    let result = try await function()
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}

