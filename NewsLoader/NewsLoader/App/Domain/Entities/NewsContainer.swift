//
//  NewsContainer.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation

struct NewsContainer: Decodable {
    let status, copyright: String?
    let numResults: Int?
    let results: [News]?

    enum CodingKeys: String, CodingKey {
        case status, copyright
        case numResults = "num_results"
        case results
    }
}
