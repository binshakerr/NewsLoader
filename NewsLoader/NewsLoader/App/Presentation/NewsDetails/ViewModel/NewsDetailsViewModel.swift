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

final class NewsDetailsViewModel: NewsDetailsViewModelType, ObservableObject {
    
    var input: Input
    var output: Output
    
    struct Input {
        let news: News
    }
    
    struct Output {
        let screenTitle: String
    }
    
    private let dataSubject = CurrentValueSubject<[DetailsCellViewModel], Never>([])
    @Published private(set) var data: DetailsCellViewModel!
    
    init(news: News) {
        self.input = Input(news: news)
        self.output = Output(screenTitle: "News Details")
        self.dataSubject.send([DetailsCellViewModel(news: news)])
        self.dataSubject.map { $0[0] }.assign(to: &$data)
    }
}
