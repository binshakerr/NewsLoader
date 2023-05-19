//
//  NetworkManager.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation
import Alamofire
import RxSwift

var customSessionManager: Session = {
    let configuration = URLSessionConfiguration.af.default
    configuration.timeoutIntervalForRequest = 30
    configuration.waitsForConnectivity = true
    let networkLogger = NetworkLogger()
    return Session(configuration: configuration, eventMonitors: [networkLogger])
}()

protocol NetworkManagerType {
    func request<T: Decodable>(_ endPoint: EndPoint, type: T.Type) -> Observable<T>
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
    
    func request<T: Decodable>(_ endPoint: EndPoint, type: T.Type) -> Observable<T> {
        
        Observable.create { [weak self] observer in
        
            guard let self = self else { return Disposables.create() }
            
            let task = Task {
                
                var urlRequest: URLRequest!
                do {
                    urlRequest = try endPoint.asURLRequest()
                } catch {
                    observer.onError(error)
                }
                
                // Check Internet Connection
                if NetworkReachability.shared.status == .notReachable {
                    observer.onError(AppError(message: "Please check your internet connectivity"))
                }
                
                // Make Request
                self.session.request(urlRequest).validate().responseData { data in
                    let result = self.parser.parseData(data, type: T.self)
                    switch result {
                    case .success(let object):
                        observer.onNext(object)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
