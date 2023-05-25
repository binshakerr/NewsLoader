//
//  NewsRepository.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation
import RxSwift

protocol NewsRepositoryType {
    func getMostPopular(period: Int) -> Observable<NewsContainer>
}


struct NewsRepository {
    
    private let networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType) {
        self.networkManager = networkManager
    }
}


extension NewsRepository: NewsRepositoryType {
    
    func getMostPopular(period: Int) -> Observable<NewsContainer> {
        let endpoint = NewsService.mostPopular(period: period)
        return networkManager.request(endpoint, type: NewsContainer.self)
    }
}
