//
//  NewsRepository.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation
import RxSwift

protocol NewsRepositoryType {
    func getMostPopular(period: Int) -> Single<NewsContainer>
}


class NewsRepository {
    
    private let networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType) {
        self.networkManager = networkManager
    }
}


extension NewsRepository: NewsRepositoryType {
    
    func getMostPopular(period: Int) -> Single<NewsContainer> {
        let endpoint = NewsService.mostPopular(period: period)
        return Single.create { observer in
            let task = Task {
                do {
                    let result = try await self.networkManager.request(endpoint, type: NewsContainer.self)
                    observer(.success(result))
                } catch {
                    observer(.failure(error))
                }
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
