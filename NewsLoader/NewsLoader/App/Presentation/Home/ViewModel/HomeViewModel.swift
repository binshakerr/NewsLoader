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
    var load: AnyObserver<Void> { get set }
    var reload: AnyObserver<Void> { get set }
}

protocol HomeViewModelOutputs: AnyObject {
    var data: Driver<[News]> { get }
    var state: Driver<DataState?> { get }
    var error: Driver<String?> { get }
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
    var load: AnyObserver<Void>
    var reload: AnyObserver<Void>
    
    //MARK: - Outputs
    let cellIdentifier = "NewsCell"
    let screenTitle = "Most Popular News"
    var data: Driver<[News]> {
        return dataSubject.asDriver()
    }
    var state: Driver<DataState?> {
        return stateSubject.asDriver()
    }
    var error: Driver<String?> {
        return errorSubject.asDriver()
    }
    
    //MARK: -
    private let newsRepository: NewsRepositoryType
    private let disposeBag = DisposeBag()
    private let dataSubject = BehaviorRelay<[News]>(value: [])
    private let stateSubject = BehaviorRelay<DataState?>(value: nil)
    private let errorSubject = BehaviorRelay<String?>(value: nil)
    private let loadMostPopularSubject = PublishSubject<Void>()
    private let reloadSubject = PublishSubject<Void>()
    private let period = 7
    
    init(newsRepository: NewsRepositoryType) {
        self.newsRepository = newsRepository
        load = loadMostPopularSubject.asObserver()
        reload = reloadSubject.asObserver()
        bindInputs()
    }
    
    private func bindInputs() {
        loadMostPopularSubject.subscribe { [weak self] _ in
            self?.fetchMostPopularNews()
        }.disposed(by: disposeBag)
        
        reloadSubject.subscribe { [weak self] _ in
            self?.refreshContent()
        }.disposed(by: disposeBag)
    }
    
    private func fetchMostPopularNews() {
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
    
    private func refreshContent() {
        stateSubject.accept(nil)
        dataSubject.accept([])
        loadMostPopularSubject.onNext(())
    }
}
