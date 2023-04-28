//
//  NewsDetailsCell.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 28/04/2023.
//

import UIKit

class NewsDetailsCell: UITableViewCell {
    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    var news: DetailsCellViewModel! {
        didSet {
            titleLabel.text = news.title
            authorLabel.text = news.author
            dateLabel.text = news.date
            detailsLabel.text = news.description
            if let url = news.imageURL {
                detailsImageView.loadImage(url: url)
            }
        }
    }
    
    @IBAction func viewStoryButtonPressed(_ sender: Any) {
        if let url = news.fullURL {
            UIApplication.shared.open(url)
        }
    }
    
}
