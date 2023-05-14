//
//  NewsDetailsViewController.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 28/04/2023.
//

import UIKit
import RxSwift
import RxCocoa

final class NewsDetailsViewController: UIViewController {
    
    //MARK: - Properties
    private let viewModel: any NewsDetailsViewModelType
    private let disposeBag = DisposeBag()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
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
        print("DEINIT \(String(describing: self))")
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
            .drive(tableView.rx.items(cellIdentifier: viewModel.output.cellIdentifier, cellType: NewsDetailsCell.self)) { (_, object, cell) in
                cell.news = object
            }
            .disposed(by: disposeBag)
    }
    
}
