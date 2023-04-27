//
//  Parser.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation
import Alamofire

protocol ParserType {
    func parseData<T: Decodable>(_ result: AFDataResponse<Any>, completion: @escaping(Result<T, Error>) -> ())
}

class Parser {
    
    private let decoder = JSONDecoder()
    
}


extension Parser: ParserType {
    
    func parseData<T: Decodable>(_ result: AFDataResponse<Any>, completion: @escaping(Result<T, Error>) -> ()) {
        switch result.result {
        case .success:
            guard let data = result.data else { return }
            do {
                let result = try decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch let error {
                print(error)
                completion(.failure(error))
            }
        case .failure(let error):
            guard let data = result.data else {
                completion(.failure(error))
                return
            }
            do {
                let errorResponse = try decoder.decode(ErrorResponse.self, from: data)
                let error = NetworkError(errorResponse: errorResponse)
                completion(.failure(error))
            } catch let error {
                print(error)
                completion(.failure(error))
            }
        }
    }
}
