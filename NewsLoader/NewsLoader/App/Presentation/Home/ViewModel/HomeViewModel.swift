//
//  HomeViewModel.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelInputs: AnyObject {
    func fetchMostPopularNews()
    func refreshContent()
}

protocol HomeViewModelOutputs: AnyObject {
    var dataSubject: BehaviorRelay<[News]> { get }
    var stateSubject: BehaviorRelay<DataState?> { get }
    var errorSubject: BehaviorRelay<String?> { get }
    var screenTitle: String { get }
    var cellIdentifier: String { get }
}


protocol HomeViewModelProtocol: HomeViewModelInputs, HomeViewModelOutputs {
    var inputs: HomeViewModelInputs { get }
    var outputs: HomeViewModelOutputs { get }
}

final class HomeViewModel: HomeViewModelProtocol {
    
    var inputs: HomeViewModelInputs { self }
    var outputs: HomeViewModelOutputs { self }
    
    //MARK: - Inputs
    let searchSubject = PublishSubject<String>()
    
    //MARK: - Outputs
    let cellIdentifier = "NewsCell"
    let screenTitle = "Most Popular News"
    let dataSubject = BehaviorRelay<[News]>(value: [])
    let stateSubject = BehaviorRelay<DataState?>(value: nil)
    let errorSubject = BehaviorRelay<String?>(value: nil)
    
    //MARK: -
    private let newsRepository: NewsRepositoryType
    private let disposeBag = DisposeBag()
    private let period = 7
    
    init(newsRepository: NewsRepositoryType) {
        self.newsRepository = newsRepository
    }
    
    func fetchMostPopularNews() {
        stateSubject.accept(.loading)
        newsRepository.getMostPopular(period: period)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                self.stateSubject.accept(response.results?.count ?? 0 > 0 ? .populated : .empty)
                self.dataSubject.accept(self.dataSubject.value + (response.results ?? []))
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self.stateSubject.accept(.error)
                self.errorSubject.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func refreshContent() {
        stateSubject.accept(nil)
        dataSubject.accept([])
        fetchMostPopularNews()
    }
}
