//
//  XCTestCase+Extensions.swift
//  NewsLoaderTests
//
//  Created by Eslam Shaker on 28/04/2023.
//

import XCTest
import Alamofire

extension XCTestCase {
    func getMockSessionFor(_ data: Data) -> Session {
        let configuration = URLSessionConfiguration.ephemeral
        MockURLProtocol.stubResponseData = data
        configuration.protocolClasses = [MockURLProtocol.self] + (configuration.protocolClasses ?? [])
        return Session(configuration: configuration)
    }
}
