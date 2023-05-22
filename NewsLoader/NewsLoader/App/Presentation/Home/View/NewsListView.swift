//
//  NewsListView.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 23/05/2023.
//

import SwiftUI

struct NewsListView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    let columns = [GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.data, id: \.self) { item in
                        NewsListCell(news: item)
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: .infinity)
            .onAppear {
                viewModel.input.load.send()
            }
            .navigationTitle(viewModel.output.screenTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct NewsListView_Previews: PreviewProvider {
    static var previews: some View {
        let repository = NewsRepository(networkManager: NetworkManager.shared)
        let useCase = GetNewsUseCase(repository: repository)
        let viewModel = HomeViewModel(getNewsUseCase: useCase)
        return NewsListView(viewModel: viewModel)
    }
}
