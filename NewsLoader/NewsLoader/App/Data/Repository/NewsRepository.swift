//
//  NewsRepository.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation
import Combine

protocol NewsRepositoryType {
    func getMostPopular(period: Int) -> AnyPublisher<NewsContainer, Error>
}


struct NewsRepository {
    
    private let networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType) {
        self.networkManager = networkManager
    }
}


extension NewsRepository: NewsRepositoryType {
    
    func getMostPopular(period: Int) -> AnyPublisher<NewsContainer, Error> {
        let endpoint = NewsService.mostPopular(period: period)
        return networkManager.request(endpoint, type: NewsContainer.self)
    }
}
