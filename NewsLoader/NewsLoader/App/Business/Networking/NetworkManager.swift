//
//  NetworkManager.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation
import Alamofire

var customSessionManager: Session = {
    let configuration = URLSessionConfiguration.af.default
    configuration.timeoutIntervalForRequest = 30
    configuration.waitsForConnectivity = true
    let networkLogger = NetworkLogger()
    return Session(configuration: configuration, eventMonitors: [networkLogger])
}()

protocol NetworkManagerType {
    func request<T: Decodable>(_ endPoint: EndPoint, type: T.Type) async throws -> T
}

final class NetworkManager {
    
    private let session: Session
    private let parser: ParserType
    static let shared = NetworkManager(session: customSessionManager, parser: Parser())
    
    init(session: Session, parser: ParserType) {
        self.session = session
        self.parser = parser
    }
    
    deinit {
        debugPrint("DEINIT \(String(describing: self))")
    }
}

extension NetworkManager: NetworkManagerType {
    
    func request<T: Decodable>(_ endPoint: EndPoint, type: T.Type) async throws -> T {
        
        var urlRequest: URLRequest
        do {
            urlRequest = try endPoint.asURLRequest()
        } catch {
            throw error
        }
        
        // Check Internet Connection
        if NetworkReachability.shared.status == .notReachable {
            throw AppError(message: "Please check your internet connectivity")
        }
        
        // Make Request
        let task = session.request(urlRequest).validate().serializingData()
        return try await parser.parseData(task.response, type: T.self)
    }
}
