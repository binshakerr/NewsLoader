//
//  MediaMetadata.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import Foundation

struct MediaMetadata: Decodable {
    let url: String?
    let format: Format?
    let height, width: Int?
}
