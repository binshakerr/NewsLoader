//
//  NewsDetailsViewController.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 28/04/2023.
//

import UIKit
import Combine

final class NewsDetailsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    //MARK: - Properties
    private let viewModel: any NewsDetailsViewModelType
    private var cancellables = Set<AnyCancellable>()
    private var news: DetailsCellViewModel!
    
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
    }
    
    private func bindViewModel() {
        viewModel
            .output
            .data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] news in
                self?.news = news.first
                self?.populateView()
            }
            .store(in: &cancellables)
    }
    
    private func populateView() {
        titleLabel.text = news.title
        authorLabel.text = news.author
        dateLabel.text = news.date
        detailsLabel.text = news.description
        if let url = news.imageURL {
            detailsImageView.loadDownsampledImage(url: url)
        }
    }
    
    //MARK: - Actions
    @IBAction func viewStoryButtonPressed(_ sender: Any) {
        if let url = news.fullURL {
            UIApplication.shared.open(url)
        }
    }
}
