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
    lazy var refreshControl = UIRefreshControl()
    
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
        viewModel.inputs.load.onNext(())
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
            .outputs
            .error
            .drive { [weak self] message in
                guard let self = self, let message = message else { return }
                self.alertError(message: message)
            }
            .disposed(by: disposeBag)
        
        viewModel
            .outputs
            .data
            .drive(tableView
                .rx
                .items(cellIdentifier: viewModel.cellIdentifier, cellType: NewsCell.self)) { (_, object, cell) in
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
                self?.viewModel.reload.onNext(())
            }
            .disposed(by: disposeBag)
    }
    
}
