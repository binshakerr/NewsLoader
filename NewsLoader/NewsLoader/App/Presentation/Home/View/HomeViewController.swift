//
//  HomeViewController.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    
    //MARK: - Properties
    private let viewModel: any HomeViewModelType
    private let disposeBag = DisposeBag()
    private let coordinator: HomeCoordinator
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: viewModel.output.cellIdentifier, bundle: nil), forCellReuseIdentifier: viewModel.output.cellIdentifier)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100
        table.refreshControl = refreshControl
        return table
    }()
    lazy var refreshControl = UIRefreshControl()
    
    //MARK: - Life cycle
    init(viewModel: any HomeViewModelType, coordinator: HomeCoordinator) {
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
        viewModel.input.load.onNext(())
    }
    
    //MARK: -
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = viewModel.output.screenTitle
        hideBackButtonTitle()
        view.addSubview(tableView)
        tableView.fillSafeArea()
    }
    
    private func bindOutputs() {
        viewModel
            .output
            .state
            .drive { [weak self] state in
                guard let self = self, let state = state else { return }
                state == .loading ? self.startLoading() : self.stopLoading()
                if state != .loading {
                    self.refreshControl.endRefreshing()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .error
            .drive { [weak self] message in
                guard let self = self, let message = message else { return }
                self.alertError(message: message)
            }
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .data
            .drive(tableView
                .rx
                .items(cellIdentifier: viewModel.output.cellIdentifier, cellType: NewsCell.self)) { (_, object, cell) in
                    cell.news = NewsCellViewModel(news: object)
                }
                .disposed(by: disposeBag)
    }
    
    private func bindInputs() {
        tableView
            .rx
            .modelSelected(News.self)
            .subscribe { [weak self] news in
                self?.coordinator.showNewsDetailsFor(news)
            }
            .disposed(by: disposeBag)
        
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .subscribe { [weak self] _ in
                self?.viewModel.input.reload.onNext(())
            }
            .disposed(by: disposeBag)
    }
    
}
