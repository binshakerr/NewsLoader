//
//  NewsCellViewModel.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 28/04/2023.
//

import Foundation

struct NewsCellViewModel {
    
    var title: String
    var author: String
    var date: String
    var thumbURL: URL?
    
    init(news: News) {
        self.title = news.title ?? ""
        self.author = news.byline ?? ""
        self.date = news.publishedDate ?? ""
        
        if let meta = news.media?.first?.mediaMetadata {
            if let thumbMeta = meta.filter({ $0.format == .standardThumbnail }).first {
                if let url = URL(string: thumbMeta.url ?? "") {
                    self.thumbURL = url
                }
            }
        }
    }
    
}
