//
//  UIViewController+Extensions.swift
//  NewsLoader
//
//  Created by Eslam Shaker on 27/04/2023.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    func showAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func alertError(message: String) {
        showAlert(title: "Error", message: message)
    }
    
    func startLoading() {
        let backgroundView = UIView(frame: view.frame)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.tag = 6006
        view.addSubview(backgroundView)
        
        let loaderSize: CGFloat = 50
        let activity = NVActivityIndicatorView(frame: CGRect(x: (view.frame.width/2) - (loaderSize/2), y: (view.frame.height/2) - (loaderSize/2), width: loaderSize, height: loaderSize), type: .lineScale)
        activity.tag = 7007
        activity.startAnimating()
        backgroundView.addSubview(activity)
    }
    
    func stopLoading() {
        if let activity = view.viewWithTag(7007) as? NVActivityIndicatorView {
            activity.stopAnimating()
            activity.removeFromSuperview()
        }
        
        if let background = view.viewWithTag(6006) {
            background.removeFromSuperview()
        }
    }
    
    func hideBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
    }
    
}
