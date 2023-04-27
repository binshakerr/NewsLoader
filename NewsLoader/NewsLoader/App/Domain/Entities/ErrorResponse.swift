//
//  ErrorResponse.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation

struct ErrorResponse: Decodable {
    let error: NLError
}
