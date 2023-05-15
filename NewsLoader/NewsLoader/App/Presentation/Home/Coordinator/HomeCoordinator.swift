//
//  HomeCoordinator.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    deinit {
        debugPrint("DEINIT \(String(describing: self))")
    }
    
    func start() {
        navigationController.setViewControllers([makeHomeScreen()], animated: true)
    }
    
    func makeHomeScreen() -> UIViewController {
        let repository = NewsRepository(networkManager: NetworkManager.shared)
        let viewModel = HomeViewModel(newsRepository: repository)
        let controller = HomeViewController(viewModel: viewModel, coordinator: self)
        return controller
    }
    
    func showNewsDetailsFor(_ news: News) {
        let viewModel = NewsDetailsViewModel(news: news)
        let controller = NewsDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }
    
}
