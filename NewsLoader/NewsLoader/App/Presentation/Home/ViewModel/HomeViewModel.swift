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

final class HomeViewModel: HomeViewModelType {
    
    var input: Input
    var output: Output
    
    struct Input {
        let load: AnyObserver<Void>
        let reload: AnyObserver<Void>
        let getNewsAt: AnyObserver<Int>
    }
    
    struct Output {
        let data: Driver<[NewsCellViewModel]>
        let state: Driver<DataState?>
        let error: Driver<Error?>
        let screenTitle: String
        let cellIdentifier: String
        let indexedNews: Driver<News?>
    }
    
    //MARK: -
    private let usecase: GetNewsUseCaseType
    private let disposeBag = DisposeBag()
    private let dataSubject = BehaviorRelay<[NewsCellViewModel]>(value: [])
    private let stateSubject = BehaviorRelay<DataState?>(value: nil)
    private let errorSubject = BehaviorRelay<Error?>(value: nil)
    private let indexNewsSubject = BehaviorRelay<News?>(value: nil)
    private let loadMostPopularSubject = PublishSubject<Void>()
    private let reloadSubject = PublishSubject<Void>()
    private let getNewsSubject = PublishSubject<Int>()
    private let period = 7
    private var news = [News]()
    
    init(usecase: GetNewsUseCaseType) {
        self.usecase = usecase
        self.input = Input(load: loadMostPopularSubject.asObserver(), reload: reloadSubject.asObserver(), getNewsAt: getNewsSubject.asObserver())
        self.output = Output(data: dataSubject.asDriver(), state: stateSubject.asDriver(), error: errorSubject.asDriver(), screenTitle: "Most Popular News", cellIdentifier: "NewsCell", indexedNews: indexNewsSubject.asDriver())
        bindInputs()
    }
    
    private func bindInputs() {
        loadMostPopularSubject.subscribe { [weak self] _ in
            self?.fetchMostPopularNews()
        }.disposed(by: disposeBag)
        
        reloadSubject.subscribe { [weak self] _ in
            self?.refreshContent()
        }.disposed(by: disposeBag)
        
        getNewsSubject.subscribe { [weak self] index in
            self?.indexNewsSubject.accept(self?.getNewsAt(index))
        }.disposed(by: disposeBag)
    }
    
    private func fetchMostPopularNews() {
        stateSubject.accept(.loading)
        usecase.getMostPopular(period: period).subscribe(onNext: { [weak self] news in
            guard let self = self else { return }
            stateSubject.accept(news.results?.count ?? 0 > 0 ? .populated : .empty)
            let sorted = (news.results ?? [])
                        .sorted { $0.publishedDate ?? "" > $1.publishedDate ?? "" }
            self.news.append(contentsOf: sorted)
            self.dataSubject.accept(self.dataSubject.value + sorted.map { NewsCellViewModel(news: $0)})
        }, onError: { [weak self] error in
            self?.stateSubject.accept(.error)
            self?.errorSubject.accept(error)
        }).disposed(by: disposeBag)
    }
    
    private func refreshContent() {
        stateSubject.accept(nil)
        news = []
        dataSubject.accept([])
        loadMostPopularSubject.onNext(())
    }
    
    private func getNewsAt(_ index: Int) -> News {
        return news[index]
    }
}
