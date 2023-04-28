//
//  MockError.swift
//  NewsLoaderTests
//
//  Created by Eslam Shaker on 28/04/2023.
//

import Foundation

enum MockError: Error, LocalizedError {
    case noDataFound
 
    var errorDescription: String? {
        switch self {
        case .noDataFound:
            return "No data found"
        }
    }
}
