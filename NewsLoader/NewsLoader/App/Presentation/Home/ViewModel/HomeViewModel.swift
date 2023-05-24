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

final class HomeViewModel: HomeViewModelType, ObservableObject {
    
    var input: Input
    var output: Output
    
    struct Input {
        let load: PassthroughSubject<Void, Never>
        let reload: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let screenTitle: String
    }
    
    //MARK: -
    private let getNewsUseCase: GetNewsUseCaseType
    private var cancellables = Set<AnyCancellable>()
    
    private let dataSubject = CurrentValueSubject<[News], Never>([])
    private let stateSubject = CurrentValueSubject<DataState?, Never>(nil)
    private let errorSubject = CurrentValueSubject<Error?, Never>(nil)
    
    @Published private(set) var data: [NewsCellViewModel] = []
    @Published private(set) var state: DataState?
    @Published private(set) var error: Error?
    
    private let loadMostPopularSubject = PassthroughSubject<Void, Never>()
    private let reloadSubject = PassthroughSubject<Void, Never>()
    private let period = 7
    private var news = [News]()
    
    init(getNewsUseCase: GetNewsUseCaseType) {
        self.getNewsUseCase = getNewsUseCase
        self.input = Input(load: loadMostPopularSubject, reload: reloadSubject)
        self.output = Output(screenTitle: "Most Popular News")
        bindInputs()
        assignOutputs()
    }
    
    private func bindInputs() {
        loadMostPopularSubject.sink { [weak self] in
            self?.fetchMostPopularNews()
        }.store(in: &cancellables)
        
        reloadSubject.sink { [weak self] in
            self?.refreshContent()
        }.store(in: &cancellables)
    }
    
    private func assignOutputs() {
        dataSubject.map {
            $0.map { NewsCellViewModel(news: $0) }
        }
        .assign(to: &$data)
        stateSubject.map { $0 }.assign(to: &$state)
        errorSubject.map { $0 }.assign(to: &$error)
    }
    
    private func fetchMostPopularNews() {
        stateSubject.send(.loading)
        getNewsUseCase
            .getMostPopular(period: period)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] status in
                guard let self = self else { return }
                switch status {
                case .failure(let error):
                    self.stateSubject.send(.error)
                    self.errorSubject.send(error)
                case .finished:
                    self.stateSubject.send(news.count > 0 ? .populated : .empty)
                    self.dataSubject.send(self.dataSubject.value + news.sorted { $0.publishedDate ?? "" > $1.publishedDate ?? "" } )
                }
            }, receiveValue: { [weak self] fetchedNews in
                self?.news += fetchedNews.results ?? []
            })
            .store(in: &cancellables)
    }
    
    private func refreshContent() {
        stateSubject.send(nil)
        dataSubject.send([])
        loadMostPopularSubject.send()
    }
    
    func getNewsAtId(_ id: Int) -> News? {
        return news.first { $0.id == id }
    }
}
