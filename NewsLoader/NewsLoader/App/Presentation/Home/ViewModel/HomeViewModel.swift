//
//  HomeViewModel.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation
import Combine

protocol HomeViewModelType: ViewModelType {
    var input: HomeViewModel.Input { get }
    var output: HomeViewModel.Output { get }
}

final class HomeViewModel: HomeViewModelType {
    
    var input: Input
    var output: Output
    
    struct Input {
        let load: PassthroughSubject<Void, Never>
        let reload: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let data: CurrentValueSubject<[News], Never>
        let state: CurrentValueSubject<DataState?, Never>
        let error: CurrentValueSubject<String?, Never>
        let screenTitle: String
        let cellIdentifier: String
    }
    
    //MARK: -
    private let newsRepository: NewsRepositoryType
    private var cancellables = Set<AnyCancellable>()
    private let dataSubject = CurrentValueSubject<[News], Never>([])
    private let stateSubject = CurrentValueSubject<DataState?, Never>(nil)
    private let errorSubject = CurrentValueSubject<String?, Never>(nil)
    private let loadMostPopularSubject = PassthroughSubject<Void, Never>()
    private let reloadSubject = PassthroughSubject<Void, Never>()
    private let period = 7
    
    init(newsRepository: NewsRepositoryType) {
        self.newsRepository = newsRepository
        self.input = Input(load: loadMostPopularSubject, reload: reloadSubject)
        self.output = Output(data: dataSubject, state: stateSubject, error: errorSubject, screenTitle: "Most Popular News", cellIdentifier: "NewsCell")
        bindInputs()
    }
    
    private func bindInputs() {
        loadMostPopularSubject.sink { [weak self] in
            self?.fetchMostPopularNews()
        }.store(in: &cancellables)
        
        reloadSubject.sink { [weak self] in
            self?.refreshContent()
        }.store(in: &cancellables)
    }
    
    private func fetchMostPopularNews() {
        stateSubject.send(.loading)
        var news = [News]()
        newsRepository
            .getMostPopular(period: period)
            .sink(receiveCompletion: { [weak self] status in
                guard let self = self else { return }
                switch status {
                case .failure(let error):
                    self.stateSubject.send(.error)
                    self.errorSubject.send(error.localizedDescription)
                case .finished:
                    self.stateSubject.send(news.count > 0 ? .populated : .empty)
                    self.dataSubject.send(self.dataSubject.value + news)
                }
            }, receiveValue: { fetchedNews in
                news += fetchedNews.results ?? []
            })
            .store(in: &cancellables)
    }
    
    private func refreshContent() {
        stateSubject.send(nil)
        dataSubject.send([])
        loadMostPopularSubject.send()
    }
}
