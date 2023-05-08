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
        let endpoint = NewsService.mostPopular(period: period)
        return Observable.create { observer in
            let task = Task {
                do {
                    let result = try await self.networkManager.request(endpoint, type: NewsContainer.self)
                    observer.on(.next(result))
                    observer.on(.completed)
                } catch {
                    observer.on(.error(error))
                }
            }
            return Disposables.create { task.cancel() }
        }
    }
}
