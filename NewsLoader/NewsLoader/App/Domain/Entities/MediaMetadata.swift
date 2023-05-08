//
//  MediaMetadata.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation

struct MediaMetadata: Decodable {
    let url: String?
    let format: String?
    let height, width: Int?
}
