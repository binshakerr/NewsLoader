//
//  NetworkError.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation

struct NetworkError: LocalizedError {
    let errorResponse: ErrorResponse
    
    var errorDescription: String? {
        return NSLocalizedString(errorResponse.error.message, comment: "")
    }
}
