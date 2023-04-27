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
    
    func start() {
        navigationController.setViewControllers([makeHomeScreen()], animated: true)
    }
    
    func makeHomeScreen() -> UIViewController {
        let repository = NewsRepository(networkManager: NetworkManager.shared)
        let viewModel = HomeViewModel(newsRepository: repository)
        let controller = HomeViewController(viewModel: viewModel, coordinator: self)
        return controller
    }
    
}
