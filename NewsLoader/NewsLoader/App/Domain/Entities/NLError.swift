//
//  NLError.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation

struct NLError: Decodable {
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case message = "faultstring"
    }
}
