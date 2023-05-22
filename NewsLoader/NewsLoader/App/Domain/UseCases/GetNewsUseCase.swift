//
//  GetNewsUseCase.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 22/05/2023.
//

import Foundation
import Combine

protocol GetNewsUseCaseType {
    func getMostPopular(period: Int) -> AnyPublisher<NewsContainer, Error>
}

struct GetNewsUseCase {
    
    private let repository: NewsRepositoryType
    
    init(repository: NewsRepositoryType) {
        self.repository = repository
    }
}


extension GetNewsUseCase: GetNewsUseCaseType {
    
    func getMostPopular(period: Int) -> AnyPublisher<NewsContainer, Error> {
        repository.getMostPopular(period: period)
    }
}
