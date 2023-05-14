//
//  MockNewsRepository.swift
//  NewsLoaderTests
//
//  Created by Eslam Shaker on 28/04/2023.
//

import Foundation
import RxSwift
@testable import NewsLoader

struct MockNewsRepository: NewsRepositoryType {
   
    var newsStubData: NewsContainer?
    
    func getMostPopular(period: Int) -> Single<NewsContainer> {
        if let newsItem = newsStubData {
            return .just(newsItem)
        }
 
        return .error(MockError.noDataFound)
    }
}
