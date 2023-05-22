//
//  NewsLoaderApp.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 20/05/2023.
//

import SwiftUI

@main
struct NewsLoaderApp: App {
    
    @EnvironmentObject var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            createHomeView()
        }
    }
    
    private func createHomeView() -> some View {
        let repository = NewsRepository(networkManager: NetworkManager.shared)
        let useCase = GetNewsUseCase(repository: repository)
        let viewModel = HomeViewModel(getNewsUseCase: useCase)
        return NewsListView(viewModel: viewModel)
    }
}
