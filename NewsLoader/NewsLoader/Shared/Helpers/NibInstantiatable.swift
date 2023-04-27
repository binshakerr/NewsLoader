//
//  NibInstantiatable.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import UIKit

/*
 use this protcol to load any view from its nib file assuming class and nib file has the same name
 ex: MyCustomView: UIView, NibInstantiatable
     MyCustomView.fromNib()
 
 //TODO: make it able to load custom nib file names
 */

public protocol NibInstantiatable {
    static func nibName() -> String
}

extension NibInstantiatable {
    static func nibName() -> String {
        return String(describing: self)
    }
}

extension NibInstantiatable where Self: UIView {
    static func fromNib() -> Self {
        let bundle = Bundle(for: self)
        let nib = bundle.loadNibNamed(nibName(), owner: self, options: nil)
        return nib!.first as! Self
    }
}
