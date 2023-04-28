//
//  NewsLoaderTests.swift
//  NewsLoaderTests
//
//  Created by Eslam Shaker on 28/04/2023.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
@testable import NewsLoader

final class NewsLoaderTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var popularNewsSuccessData: Data!
    var homeViewModel: HomeViewModelProtocol!
    var detailsViewModel: NewsDetailsViewModel!
    var networkManager: NetworkManagerType!
    let timeOut: Double = 10
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        networkManager = nil
        popularNewsSuccessData = nil
        homeViewModel = nil
        detailsViewModel = nil
        scheduler = nil
        disposeBag = nil
    }
    
    //MARK: - Home Tests
    func test_HomeViewModel_InitialState() {
        networkManager = NetworkManager.shared
        homeViewModel = HomeViewModel(newsRepository: NewsRepository(networkManager: networkManager))

        XCTAssertTrue(try homeViewModel.outputs.data.toBlocking().first()?.count == 0)
        XCTAssertEqual(homeViewModel.outputs.screenTitle, "Most Popular News")
        XCTAssertEqual(homeViewModel.outputs.cellIdentifier, "NewsCell")
    }

    func test_PopularNews_Success() {
        // Given
        popularNewsSuccessData = Utils.MockResponseType.successNewsData.sampleDataFor(self)
        let session = getMockSessionFor(popularNewsSuccessData)
        networkManager = NetworkManager(session: session, parser: Parser())
        let newsRepository = NewsRepository(networkManager: networkManager)
        homeViewModel = HomeViewModel(newsRepository: newsRepository)

        // When
        let newsObserver = scheduler.createObserver([News].self)
        homeViewModel.outputs.data
            .asObservable()
            .subscribe(newsObserver)
            .disposed(by: disposeBag)
        scheduler.createHotObservable([(.next(10, true))])
            .bind(to: homeViewModel.inputs.loadMostPopular)
            .disposed(by: disposeBag)
        scheduler.start()

        // Then
        let newsElement = newsObserver.events.last?.value.element
        XCTAssertEqual(newsElement?.count, 20)
    }
    
    
    //MARK: - Details test

    func test_DetailsViewModel_InitialState() {
        let mockNews = News(uri: nil, url: nil, id: nil, assetID: nil, source: nil, publishedDate: nil, updated: nil, section: nil, subsection: nil, nytdsection: nil, adxKeywords: nil, byline: nil, type: nil, title: nil, abstract: nil, desFacet: nil, orgFacet: nil, perFacet: nil, geoFacet: nil, media: nil, etaID: nil)
        detailsViewModel = NewsDetailsViewModel(news: mockNews)

        XCTAssertTrue(try detailsViewModel.outputs.data.toBlocking().first()?.count == 1)
        XCTAssertEqual(detailsViewModel.outputs.screenTitle, "News Details")
        XCTAssertEqual(detailsViewModel.outputs.cellIdentifier, "NewsDetailsCell")
    }
    
}
