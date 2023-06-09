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
    var homeViewModel: (any HomeViewModelType)?
    var detailsViewModel: (any NewsDetailsViewModelType)?
    var networkManager: NetworkManagerType!
    var newsRepository: MockNewsRepository!
    
    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
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

        XCTAssertTrue(try homeViewModel?.output.data.toBlocking().first()?.count == 0)
        XCTAssertEqual(homeViewModel?.output.screenTitle, "Most Popular News")
        XCTAssertEqual(homeViewModel?.output.cellIdentifier, "NewsCell")
    }

    func test_PopularNews_Success() {
        // Given
        popularNewsSuccessData = Utils.MockResponseType.successNewsData.sampleDataFor(self)
        let decodedItem = try? JSONDecoder().decode(NewsContainer.self, from: popularNewsSuccessData)
        newsRepository.newsStubData = decodedItem
        homeViewModel = HomeViewModel(newsRepository: newsRepository)

        // When
        let newsObserver = scheduler.createObserver([News].self)
        homeViewModel?.output.data
            .asObservable()
            .bind(to: newsObserver)
            .disposed(by: disposeBag)
        scheduler.createColdObservable([(.next(10, ()))])
            .bind(to: (homeViewModel?.input.load)!)
            .disposed(by: disposeBag)
        scheduler.start()

        // Then
        let newsElement = newsObserver.events.last?.value.element
        XCTAssertEqual(newsElement?.count, 20)
        XCTAssertEqual(newsElement?[15].abstract, "The court’s order seemed to vindicate a commitment in last year’s decision in Dobbs: to leave further questions about abortion to the political process.")
        XCTAssertEqual(newsElement?[7].title, "Airman Shared Sensitive Intelligence More Widely and for Longer Than Previously Known")
    }
    
    
    //MARK: - Details test

    func test_DetailsViewModel_InitialState() {
        let mockNews = News(uri: nil, url: nil, id: nil, assetID: nil, source: nil, publishedDate: nil, updated: nil, section: nil, subsection: nil, nytdsection: nil, adxKeywords: nil, byline: nil, type: nil, title: nil, abstract: nil, desFacet: nil, orgFacet: nil, perFacet: nil, geoFacet: nil, media: nil, etaID: nil)
        detailsViewModel = NewsDetailsViewModel(news: mockNews)

        XCTAssertTrue(try detailsViewModel?.output.data.toBlocking().first()?.count == 1)
        XCTAssertEqual(detailsViewModel?.output.screenTitle, "News Details")
        XCTAssertEqual(detailsViewModel?.output.cellIdentifier, "NewsDetailsCell")
    }
    
}
