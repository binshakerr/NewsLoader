//
//  Parser.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation
import Alamofire

protocol ParserType {
    func parseData<T: Decodable>(_ result: DataResponse<Data, AFError>, type: T.Type) async throws -> T
}

class Parser {
    private let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
    }
}


extension Parser: ParserType {
    
    func parseData<T: Decodable>(_ response: DataResponse<Data, AFError>, type: T.Type) async throws -> T {
        switch response.result {
        case .success:
            guard let data = response.data else {
                throw AppError(message: "No Data")
            }
            do {
                return try decoder.decode(T.self, from: data)
            } catch let error {
                print(error)
                throw error
            }
        case .failure(let error):
            guard let data = response.data else {
                throw error
            }
            do {
                let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                throw NetworkError(errorResponse: errorResponse)
            } catch let error {
                print(error)
                throw error
            }
        }
    }
}
