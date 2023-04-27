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
    func request<T: Decodable>(_ endPoint: EndPoint, type: T.Type, completion: @escaping(Result<T, Error>) -> ())
}

class NetworkManager {
    
    private let session: Session
    private let parser: ParserType
    static let shared = NetworkManager(session: customSessionManager, parser: Parser())
    
    init(session: Session, parser: ParserType) {
        self.session = session
        self.parser = parser
    }
}

extension NetworkManager: NetworkManagerType {
    
    func request<T: Decodable>(_ endPoint: EndPoint, type: T.Type, completion: @escaping(Result<T, Error>) -> ()) {
        
        var urlRequest: URLRequest!
        do {
            urlRequest = try endPoint.asURLRequest()
        } catch {
            completion(.failure(error))
        }
        
        // Check Internet Connection
        if NetworkReachability.shared.status == .notReachable {
            let error = AppError(message: "Please check your internet connectivity")
            completion(.failure(error))
        }
        
        // Make Request
        session
            .request(urlRequest)
            .validate()
            .responseJSON { [weak self] result in
                self?.parser.parseData(result) { result in
                    completion(result)
                }
            }
    }
    
    
}
