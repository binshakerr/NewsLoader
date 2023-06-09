//
//  NewsCell.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 28/04/2023.
//

import UIKit

final class NewsCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.makeRounded()
    }
    
    deinit {
        debugPrint("DEINIT \(String(describing: self))")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    var news: NewsCellViewModel! {
        didSet {
            titleLabel.text = news.title
            authorLabel.text = news.author
            dateLabel.text = news.date
            if let url = news.thumbURL {
                thumbnailImageView.loadDownsampledImage(url: url)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil 
    }
    
}
