//
//  HomeViewModel.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelType: ViewModelType {
    var input: HomeViewModel.Input { get }
    var output: HomeViewModel.Output { get }
}

struct HomeViewModel: HomeViewModelType {
    
    var input: Input
    var output: Output
    
    struct Input {
        let load: AnyObserver<Void>
        let reload: AnyObserver<Void>
    }
    
    struct Output {
        let data: Driver<[News]>
        let state: Driver<DataState?>
        let error: Driver<Error?>
        let screenTitle: String
        let cellIdentifier: String
    }
    
    //MARK: -
    private let usecase: GetNewsUseCaseType
    private let disposeBag = DisposeBag()
    private let dataSubject = BehaviorRelay<[News]>(value: [])
    private let stateSubject = BehaviorRelay<DataState?>(value: nil)
    private let errorSubject = BehaviorRelay<Error?>(value: nil)
    private let loadMostPopularSubject = PublishSubject<Void>()
    private let reloadSubject = PublishSubject<Void>()
    private let period = 7
    
    init(usecase: GetNewsUseCaseType) {
        self.usecase = usecase
        self.input = Input(load: loadMostPopularSubject.asObserver(), reload: reloadSubject.asObserver())
        self.output = Output(data: dataSubject.asDriver(), state: stateSubject.asDriver(), error: errorSubject.asDriver(), screenTitle: "Most Popular News", cellIdentifier: "NewsCell")
        bindInputs()
    }
    
    private func bindInputs() {
        loadMostPopularSubject.subscribe { _ in
            fetchMostPopularNews()
        }.disposed(by: disposeBag)
        
        reloadSubject.subscribe { _ in
            refreshContent()
        }.disposed(by: disposeBag)
    }
    
    private func fetchMostPopularNews() {
        stateSubject.accept(.loading)
        usecase.getMostPopular(period: period).subscribe(onNext: { news in
            stateSubject.accept(news.results?.count ?? 0 > 0 ? .populated : .empty)
            dataSubject.accept(dataSubject.value + (news.results ?? []))
        }, onError: { error in
            stateSubject.accept(.error)
            errorSubject.accept(error)
        }).disposed(by: disposeBag)
    }
    
    private func refreshContent() {
        stateSubject.accept(nil)
        dataSubject.accept([])
        loadMostPopularSubject.onNext(())
    }
}
