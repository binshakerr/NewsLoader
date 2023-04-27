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


class NewsRepository {
    
    private let networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType) {
        self.networkManager = networkManager
    }
}


extension NewsRepository: NewsRepositoryType {
    
    func getMostPopular(period: Int) -> Observable<NewsContainer> {
        return Observable.create { [weak self] observer in
            let request = NewsService.mostPopular(period: period)
            self?.networkManager.request(request, type: NewsContainer.self) { result in
                switch result {
                case .success(let response):
                    observer.onNext(response)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
