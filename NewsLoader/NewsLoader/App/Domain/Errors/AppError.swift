//
//  AppError.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation

struct AppError: LocalizedError {
    let message: String
    
    var errorDescription: String? {
        return NSLocalizedString(message, comment: "")
    }
}
