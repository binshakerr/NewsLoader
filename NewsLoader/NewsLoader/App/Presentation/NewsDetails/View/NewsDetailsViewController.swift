//
//  NewsDetailsViewController.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 28/04/2023.
//

import UIKit
import RxSwift
import RxCocoa

class NewsDetailsViewController: UIViewController {
    
    //MARK: - Properties
    private let viewModel: NewsDetailsViewModelProtocol
    private let disposeBag = DisposeBag()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UINib(nibName: viewModel.cellIdentifier, bundle: nil), forCellReuseIdentifier: viewModel.cellIdentifier)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 500
        table.separatorStyle = .none
        return table
    }()
    
    //MARK: - Life cycle
    init(viewModel: NewsDetailsViewModelProtocol) {
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
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = viewModel.outputs.screenTitle
        view.addSubview(tableView)
        tableView.fillSafeArea()
    }
    
    private func bindViewModel() {
        viewModel
            .outputs
            .data
            .drive(tableView.rx.items(cellIdentifier: viewModel.cellIdentifier, cellType: NewsDetailsCell.self)) { (_, object, cell) in
                cell.news = object
            }
            .disposed(by: disposeBag)
    }
    
}
