//
//  NewsDetailsViewModel.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 28/04/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol NewsDetailsViewModelInputs: AnyObject {
    var news: News { get }
}

protocol NewsDetailsViewModelOutputs: AnyObject {
    var screenTitle: String { get }
    var cellIdentifier: String { get }
    var data: Driver<[DetailsCellViewModel]> { get }
}


protocol NewsDetailsViewModelProtocol: NewsDetailsViewModelInputs, NewsDetailsViewModelOutputs {
    var inputs: NewsDetailsViewModelInputs { get }
    var outputs: NewsDetailsViewModelOutputs { get }
}


final class NewsDetailsViewModel: NewsDetailsViewModelProtocol {
    
    var inputs: NewsDetailsViewModelInputs { self }
    var outputs: NewsDetailsViewModelOutputs { self }
    
    var news: News
    private let dataSubject = BehaviorRelay<[DetailsCellViewModel]>(value: [])
    var data: Driver<[DetailsCellViewModel]> {
        return dataSubject.asDriver()
    }

    init(news: News) {
        self.news = news
        self.dataSubject.accept([DetailsCellViewModel(news: news)])
    }
    
    var screenTitle: String {
        "News Details"
    }
    
    var cellIdentifier: String {
        "NewsDetailsCell"
    }
    
}
