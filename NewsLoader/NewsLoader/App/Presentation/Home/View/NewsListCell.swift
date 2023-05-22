//
//  NewsListCell.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 23/05/2023.
//

import SwiftUI
import Kingfisher

struct NewsListCell: View {
    
    @State var news: NewsCellViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack(alignment: .top) {
                KFImage(news.thumbURL)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 45, height: 45)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(news.title)
                        .font(.custom("Avenir Next", size: 16))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    Text(news.author)
                        .font(.custom("Avenir Next", size: 14))
                        .fontWeight(.regular)
                        .multilineTextAlignment(.leading)
                    
                    Text(news.date)
                        .font(.custom("Avenir Next", size: 12))
                        .fontWeight(.regular)
                        .foregroundColor(Color.gray)
                }
            }
            
            Divider()
        }
    }
}

struct NewsListCell_Previews: PreviewProvider {
    static var previews: some View {
        let original = News(uri: "", url: "", id: nil, assetID: nil, source: nil, publishedDate: "06-12-2023", updated: nil, section: nil, subsection: nil, nytdsection: nil, adxKeywords: nil, byline: "Eslam Shaker", type: nil, title: "Today News", abstract: "gujwnrgjerngonnbetojbnetobn", desFacet: nil, orgFacet: nil, perFacet: nil, geoFacet: nil, media: [Media(type: nil, subtype: nil, caption: nil, copyright: nil, approvedForSyndication: nil, mediaMetadata: [MediaMetadata(url: "https://pbs.twimg.com/profile_images/1108430392267280389/ufmFwzIn_400x400.png", format: "Standard Thumbnail", height: nil, width: nil)])], etaID: nil)
        let news = NewsCellViewModel(news: original)
        NewsListCell(news: news)
            .previewLayout(.sizeThatFits)
    }
}
