//
//  MockNewsRepository.swift
//  NewsLoaderTests
//
//  Created by Eslam Shaker on 28/04/2023.
//

import Foundation
import Combine
@testable import NewsLoader

struct MockNewsRepository: NewsRepositoryType {
    
    var newsStubData: NewsContainer?
    
    func getMostPopular(period: Int) -> AnyPublisher<NewsContainer, Error> {
        return Future<NewsContainer, Error> { promise in
            if let newsItem = newsStubData {
                promise(.success(newsItem))
            } else {
                promise(.failure(MockError.noDataFound))
            }
        }.eraseToAnyPublisher()
    }
}
