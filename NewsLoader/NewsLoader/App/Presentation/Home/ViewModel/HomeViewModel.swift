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
    }

    struct Output {
        let data: Driver<[News]>
        let state: Driver<DataState?>
        let error: Driver<String?>
        let screenTitle: String
        let cellIdentifier: String
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
        self.input = Input(load: loadMostPopularSubject.asObserver(), reload: reloadSubject.asObserver())
        self.output = Output(data: dataSubject.asDriver(), state: stateSubject.asDriver(), error: errorSubject.asDriver(), screenTitle: "Most Popular News", cellIdentifier: "NewsCell")
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
        newsRepository.getMostPopular(period: period).subscribe { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let news):
                self.stateSubject.accept(news.results?.count ?? 0 > 0 ? .populated : .empty)
                self.dataSubject.accept(self.dataSubject.value + (news.results ?? []))
            case .failure(let error):
                self.stateSubject.accept(.error)
                self.errorSubject.accept(error.localizedDescription)
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func refreshContent() {
        stateSubject.accept(nil)
        dataSubject.accept([])
        loadMostPopularSubject.onNext(())
    }
}
