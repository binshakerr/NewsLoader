//
//  NewsLoaderTests.swift
//  NewsLoaderTests
//
//  Created by Eslam Shaker on 28/04/2023.
//

import XCTest
import Combine
@testable import NewsLoader

final class NewsLoaderTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var popularNewsSuccessData: Data!
    var homeViewModel: (any HomeViewModelType)!
    var detailsViewModel: (any NewsDetailsViewModelType)!
    var networkManager: NetworkManagerType!
    var newsRepository: MockNewsRepository!
    
    override func setUp() {
        cancellables = Set<AnyCancellable>()
        newsRepository = MockNewsRepository()
    }
    
    override func tearDown() {
        networkManager = nil
        popularNewsSuccessData = nil
        homeViewModel = nil
        detailsViewModel = nil
        newsRepository = nil
    }
    
    //MARK: - Home Tests
    func test_HomeViewModel_InitialState() {
        homeViewModel = HomeViewModel(newsRepository: newsRepository)
        
        XCTAssertEqual(homeViewModel.output.data.value.count, 0)
        XCTAssertEqual(homeViewModel.output.screenTitle, "Most Popular News")
        XCTAssertEqual(homeViewModel.output.cellIdentifier, "NewsCell")
    }
    
    func test_PopularNews_Success() {
        // Given
        popularNewsSuccessData = Utils.MockResponseType.successNewsData.sampleDataFor(self)
        let decodedItem = try? JSONDecoder().decode(NewsContainer.self, from: popularNewsSuccessData)
        newsRepository.newsStubData = decodedItem
        homeViewModel = HomeViewModel(newsRepository: newsRepository)
        var error: Error?
        var news = [News]()
        
        // When
        let expectation = expectation(description: "get data when loading")

        homeViewModel
            .output
            .data
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let encounteredError):
                    error = encounteredError
                case .finished:
                    break
                }
                // Then
                XCTAssertNil(error)
                XCTAssertEqual(news.count, 20)
                XCTAssertEqual(news[15].abstract, "The court’s order seemed to vindicate a commitment in last year’s decision in Dobbs: to leave further questions about abortion to the political process.")
                XCTAssertEqual(news[7].title, "Airman Shared Sensitive Intelligence More Widely and for Longer Than Previously Known")
               
                expectation.fulfill()
            }, receiveValue: { new in
                news = new
            })
            .store(in: &cancellables)
        
        homeViewModel.input.load.send()

        wait(for: [expectation], timeout: 10)
    }
    
    
    //MARK: - Details test
    
    func test_DetailsViewModel_InitialState() {
        let mockNews = News(uri: nil, url: nil, id: nil, assetID: nil, source: nil, publishedDate: nil, updated: nil, section: nil, subsection: nil, nytdsection: nil, adxKeywords: nil, byline: nil, type: nil, title: nil, abstract: nil, desFacet: nil, orgFacet: nil, perFacet: nil, geoFacet: nil, media: nil, etaID: nil)
        detailsViewModel = NewsDetailsViewModel(news: mockNews)
        
        XCTAssertEqual(detailsViewModel.output.data.value.count, 1)
        XCTAssertEqual(detailsViewModel.output.screenTitle, "News Details")
        XCTAssertEqual(detailsViewModel.output.cellIdentifier, "NewsDetailsCell")
    }
    
}
