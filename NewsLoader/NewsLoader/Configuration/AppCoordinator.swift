//
//  AppCoordinator.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    deinit {
        debugPrint("DEINIT \(String(describing: self))")
    }
    
    func start() {
        let navigation = UINavigationController()
        makeHomeCoordinator(navigation)
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
    
    private func makeHomeCoordinator(_ navigation: UINavigationController) {
        let homeCoordinator = HomeCoordinator(navigationController: navigation)
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
}
