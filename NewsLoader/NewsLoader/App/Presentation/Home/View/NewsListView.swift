//
//  NewsListView.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 23/05/2023.
//

import SwiftUI

struct NewsListView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    @State private var showErrorAlert = false
    private let columns = [GridItem(.flexible())]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.data, id: \.self) { item in
                        NavigationLink(destination: createDetailsView(id: item.id)) {
                            NewsListCell(news: item)
                        }
                    }
                }
                .padding()
            }
            .onLoad {
                viewModel.input.load.send()
            }
            .onReceive(viewModel.$error) { error in
                showErrorAlert = error != nil
            }
            .navigationTitle(viewModel.output.screenTitle)
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.error?.localizedDescription ?? ""),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    private func createDetailsView(id: Int) -> AnyView {
        guard let news = viewModel.getNewsAtId(id) else { return AnyView(EmptyView()) }
        let viewModel = NewsDetailsViewModel(news: news)
        return AnyView(NewsDetailsView(viewModel: viewModel))
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
