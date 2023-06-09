//
//  MockURLProtocol.swift
//  NewsLoaderTests
//
//  Created by Eslam Shaker on 28/04/2023.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    
    static var stubResponseData: Data?
    private(set) var activeTask: URLSessionTask?
    
    deinit {
        debugPrint("DEINIT \(String(describing: self))")
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    override func startLoading() {
        self.client?.urlProtocol(self, didLoad: MockURLProtocol.stubResponseData ?? Data())
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
}
