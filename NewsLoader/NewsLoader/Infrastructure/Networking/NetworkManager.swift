//
//  NetworkManager.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation
import Alamofire
import Combine

var customSessionManager: Session = {
    let configuration = URLSessionConfiguration.af.default
    configuration.timeoutIntervalForRequest = 30
    configuration.waitsForConnectivity = true
    let networkLogger = NetworkLogger()
    return Session(configuration: configuration, eventMonitors: [networkLogger])
}()

protocol NetworkManagerType {
    func request<T: Decodable>(_ endPoint: EndPoint, type: T.Type) -> AnyPublisher<T, Error>
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
    
    func request<T: Decodable>(_ endPoint: EndPoint, type: T.Type) -> AnyPublisher<T, Error> {
        
        return Future<T, Error> { [weak self] promise in
            
            guard let self = self else { return }
            
            var urlRequest: URLRequest!
            do {
                urlRequest = try endPoint.asURLRequest()
            } catch {
                promise(.failure(error))
            }
            
            // Check Internet Connection
            if NetworkReachability.shared.status == .notReachable {
                promise(.failure(AppError(message: "Please check your internet connectivity")))
            }
            
            // Make Request
            self.session.request(urlRequest).validate().responseData { data in
                let result = self.parser.parseData(data, type: T.self)
                promise(result)
            }
        }
        .eraseToAnyPublisher()
    }
}
