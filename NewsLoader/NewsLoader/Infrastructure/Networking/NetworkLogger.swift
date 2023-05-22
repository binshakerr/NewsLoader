//
//  NetworkLogger.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation
import Alamofire

struct NetworkLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "com.listloader.networklogger")
    
    func requestDidFinish(_ request: Request) {
        debugPrint(request.description)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let data = response.data else {
            return
        }
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            debugPrint(json)
        }
    }
}
