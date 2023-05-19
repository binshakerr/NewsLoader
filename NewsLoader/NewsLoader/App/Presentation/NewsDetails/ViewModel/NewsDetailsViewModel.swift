//
//  NewsDetailsViewModel.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 28/04/2023.
//

import Foundation
import Combine

protocol NewsDetailsViewModelType: ViewModelType {
    var input: NewsDetailsViewModel.Input { get }
    var output: NewsDetailsViewModel.Output { get }
}

struct NewsDetailsViewModel: NewsDetailsViewModelType {
    
    var input: Input
    var output: Output
    
    struct Input {
        let news: News
    }

    struct Output {
        let screenTitle: String
        let cellIdentifier: String
        let data: CurrentValueSubject<[DetailsCellViewModel], Never>
    }
    
    private let dataSubject = CurrentValueSubject<[DetailsCellViewModel], Never>([])
   
    init(news: News) {
        self.input = Input(news: news)
        self.output = Output(screenTitle: "News Details", cellIdentifier: "NewsDetailsCell", data: dataSubject)
        self.dataSubject.send([DetailsCellViewModel(news: news)])
    }
}
