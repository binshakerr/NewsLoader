//
//  GetNewsUseCase.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 25/05/2023.
//

import Foundation
import RxSwift

protocol GetNewsUseCaseType {
    func getMostPopular(period: Int) -> Observable<NewsContainer>
}

struct GetNewsUseCase {
    
    private let repository: NewsRepositoryType
    
    init(repository: NewsRepositoryType) {
        self.repository = repository
    }
}


extension GetNewsUseCase: GetNewsUseCaseType {
    
    func getMostPopular(period: Int) -> Observable<NewsContainer> {
        repository.getMostPopular(period: period)
    }
}
