//
//  NewsDetailsViewController.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 28/04/2023.
//

import UIKit
import Combine

final class NewsDetailsViewController: UIViewController {
    
    //MARK: - Properties
    private let viewModel: any NewsDetailsViewModelType
    private var cancellables = Set<AnyCancellable>()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.register(UINib(nibName: viewModel.output.cellIdentifier, bundle: nil), forCellReuseIdentifier: viewModel.output.cellIdentifier)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 500
        table.separatorStyle = .none
        return table
    }()
    
    //MARK: - Life cycle
    init(viewModel: any NewsDetailsViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    deinit {
        debugPrint("DEINIT \(String(describing: self))")
    }
    
    //MARK: -
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = viewModel.output.screenTitle
        view.addSubview(tableView)
        tableView.fillSafeArea()
    }
    
    private func bindViewModel() {
        viewModel
            .output
            .data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}


extension NewsDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.output.data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.output.cellIdentifier, for: indexPath) as? NewsDetailsCell else {
            return UITableViewCell()
        }
        cell.news = viewModel.output.data.value.first
        return cell
    }
}
