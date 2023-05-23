//
//  NewsDetailsView.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 23/05/2023.
//

import SwiftUI
import Kingfisher

struct NewsDetailsView: View {
    
    @ObservedObject var viewModel: NewsDetailsViewModel
    
    var body: some View {
        GeometryReader { metrics in
            VStack {
                ScrollView {
                    VStack(spacing: 5) {
                        
                        KFImage(viewModel.data.imageURL)
                            .resizable()
                            .scaledToFill()
                            .background(Color.secondary)
                            .frame(height: metrics.size.height * 0.33)
                            .clipped()
                        
                        articleInfoStack
                            .padding()
                        
                        Text(viewModel.data.description)
                            .font(.custom("Avenir Next", size: 14))
                            .fontWeight(.regular)
                            .foregroundColor(Color.primary)
                            .multilineTextAlignment(.leading)
                            .padding()
                    }
                }
                
                Spacer()
                
                viewArticleButton
                    .padding()
            }
            .navigationTitle(viewModel.output.screenTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var articleInfoStack: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(viewModel.data.title)
                .font(.custom("Avenir Next", size: 16))
                .fontWeight(.bold)
                .foregroundColor(Color.primary)
                .multilineTextAlignment(.leading)
            
            Text(viewModel.data.author)
                .font(.custom("Avenir Next", size: 14))
                .fontWeight(.regular)
                .foregroundColor(Color.primary)
                .multilineTextAlignment(.leading)
            
            Text(viewModel.data.date)
                .font(.custom("Avenir Next", size: 12))
                .fontWeight(.regular)
                .foregroundColor(Color.secondary)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var viewArticleButton: some View {
        Button(action:  {
            if let url = viewModel.data.fullURL {
                UIApplication.shared.open(url)
            }
        }) {
            Text("View Original Story")
                .font(.custom("Avenir Next", size: 17))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor.systemTeal))
                .cornerRadius(16)
                .shadow(color: .gray, radius: 2, x: 0, y: 2)
        }
    }
}

struct NewsDetailsView_Previews: PreviewProvider {
    
    static var previews: some View {
        let news = News(uri: "", url: "", id: nil, assetID: nil, source: nil, publishedDate: "06-12-2023", updated: nil, section: nil, subsection: nil, nytdsection: nil, adxKeywords: nil, byline: "Eslam Shaker", type: nil, title: "Today News", abstract: "gujwnrgjerngonnbetojbnetobn", desFacet: nil, orgFacet: nil, perFacet: nil, geoFacet: nil, media: [Media(type: nil, subtype: nil, caption: nil, copyright: nil, approvedForSyndication: nil, mediaMetadata: [MediaMetadata(url: "https://pbs.twimg.com/profile_images/1108430392267280389/ufmFwzIn_400x400.png", format: "Standard Thumbnail", height: nil, width: nil)])], etaID: nil)
        let viewModel = NewsDetailsViewModel(news: news)
        NewsDetailsView(viewModel: viewModel)
    }
}
