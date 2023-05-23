//
//  UINavigationController+Extensions.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 23/05/2023.
//

import UIKit

extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
