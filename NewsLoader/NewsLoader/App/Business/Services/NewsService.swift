//
//  NewsService.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation
import Alamofire

fileprivate enum Constants: String {
    case baseURL = "https://api.nytimes.com/svc"
    case ApiKey = "ukEm46Gx489uaEIAA9IGmsBojzG10oDo"
}

enum NewsService {
    case mostPopular(period: Int)
}

extension NewsService: EndPoint {
    
    var path: String {
        switch self {
        case .mostPopular(let period):
            return "/mostpopular/v2/viewed/\(period)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .mostPopular:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .mostPopular:
            return ["api-key": Constants.ApiKey.rawValue] as [String : Any]
        }
    }
    
    var baseURL: URL {
        return URL(string: Constants.baseURL.rawValue)!
    }
    
    var headers: [String : String] {
        return [
            HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
            HTTPHeaderField.acceptType.rawValue: ContentType.json.rawValue,
        ]
    }
    
}
