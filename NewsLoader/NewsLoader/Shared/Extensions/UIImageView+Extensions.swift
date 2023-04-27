//
//  UIImageView+Extensions.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    //load normal image size
    func loadImage(url: URL, placeholder: UIImage? = nil) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: placeholder)
    }
    
    //load smaller image sizes for usage in small imageviews (ex: like in tableviewcell or collectionviewcell), rather than displaying the larger image
    func loadDownsampledImage(url: URL, placeholder: UIImage? = nil) {
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .processor(DownsamplingImageProcessor(size: self.bounds.size)),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ])
    }
    
}
