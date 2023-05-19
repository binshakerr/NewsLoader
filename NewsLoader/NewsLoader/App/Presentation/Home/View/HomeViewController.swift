//
//  HomeViewController.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {
    
    //MARK: - Properties
    private let viewModel: any HomeViewModelType
    private var cancellables = Set<AnyCancellable>()
    private let coordinator: HomeCoordinator
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: viewModel.output.cellIdentifier, bundle: nil), forCellReuseIdentifier: viewModel.output.cellIdentifier)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 100
        table.refreshControl = refreshControl
        return table
    }()
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refresh
    }()
    
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
        bindOutputs()
        viewModel.input.load.send()
    }
    
    deinit {
        debugPrint("DEINIT \(String(describing: self))")
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
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self, let state = state else { return }
                state == .loading ? self.startLoading() : self.stopLoading()
                if state != .loading {
                    self.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        viewModel
            .output
            .error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self = self, let message = message else { return }
                self.alertError(message: message)
            }
            .store(in: &cancellables)
        
        viewModel
            .output
            .data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func refreshData() {
        viewModel.input.reload.send()
    }
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.output.data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.output.cellIdentifier, for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        cell.news = NewsCellViewModel(news: viewModel.output.data.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator.showNewsDetailsFor(viewModel.output.data.value[indexPath.row])
    }
}
