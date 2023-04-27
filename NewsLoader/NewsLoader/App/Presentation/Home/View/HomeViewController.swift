//
//  HomeViewController.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    //MARK: - Properties
    private let viewModel: HomeViewModelProtocol
    private let disposeBag = DisposeBag()
    private let coordinator: HomeCoordinator
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: viewModel.cellIdentifier, bundle: nil), forCellReuseIdentifier: viewModel.cellIdentifier)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100
        table.refreshControl = refreshControl
        return table
    }()
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refreshContent(_:)), for: .valueChanged)
        return refresh
    }()
    
    //MARK: - Life cycle
    init(viewModel: HomeViewModelProtocol, coordinator: HomeCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindInputs()
        bindOutputs()
        viewModel.fetchMostPopularNews()
    }
    
    //MARK: -
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = viewModel.outputs.screenTitle
        hideBackButtonTitle()
        view.addSubview(tableView)
        tableView.fillSafeArea()
    }
    
    private func bindOutputs() {
        viewModel
            .outputs
            .stateSubject
            .subscribe(onNext:  { [weak self] state in
                guard let self = self, let state = state else { return }
                state == .loading ? self.startLoading() : self.stopLoading()
                if state != .loading {
                    self.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel
            .outputs
            .errorSubject
            .subscribe(onNext:  { [weak self] message in
                guard let self = self, let message = message else { return }
                self.alertError(message: message)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .outputs
            .dataSubject
            .bind(to: tableView
                .rx
                .items(cellIdentifier: viewModel.cellIdentifier, cellType: NewsCell.self)) { (items, object, cell) in
                    cell.news = NewsCellViewModel(news: object)
                }
                .disposed(by: disposeBag)
    }
    
    private func bindInputs() {
        tableView
            .rx
            .modelSelected(News.self)
            .subscribe(onNext:  { [weak self] news in
//                self?.coordinator.
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    private func refreshContent(_ sender: AnyObject) {
        viewModel.refreshContent()
    }
    

}
