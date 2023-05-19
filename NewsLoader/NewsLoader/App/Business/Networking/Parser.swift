//
//  Parser.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation
import Alamofire

protocol ParserType {
    func parseData<T: Decodable>(_ result: AFDataResponse<Data>, type: T.Type) -> Result<T, Error>
}

struct Parser {
    private let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
    }
}


extension Parser: ParserType {
    
    func parseData<T: Decodable>(_ response: AFDataResponse<Data>, type: T.Type) -> Result<T, Error> {
        switch response.result {
        case .success:
            guard let data = response.data else {
                return .failure(AppError(message: "No Data"))
            }
            do {
                let object = try decoder.decode(T.self, from: data)
                return .success(object)
            } catch let error {
                debugPrint(error)
                return .failure(error)
            }
        case .failure(let error):
            guard let data = response.data else {
                return .failure(error)
            }
            do {
                let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                return .failure(NetworkError(errorResponse: errorResponse))
            } catch let error {
                debugPrint(error)
                return .failure(error)
            }
        }
    }
}
