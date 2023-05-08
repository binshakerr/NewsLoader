//
//  DetailsCellViewModel.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 28/04/2023.
//

import Foundation

struct DetailsCellViewModel {
    var title: String
    var author: String
    var date: String
    var description: String
    var imageURL: URL?
    var fullURL: URL?
    
    init(news: News) {
        self.title = news.title ?? ""
        self.author = news.byline ?? ""
        self.date = news.publishedDate ?? ""
        self.description = news.abstract ?? ""
        
        if let meta = news.media?.first?.mediaMetadata {
            if let imageMeta = meta.filter({ $0.format == "mediumThreeByTwo440" }).first {
                if let url = URL(string: imageMeta.url ?? "") {
                    self.imageURL = url
                }
            }
        }
        
        if let story = news.url {
            fullURL = URL(string: story)
        }
    }
}
