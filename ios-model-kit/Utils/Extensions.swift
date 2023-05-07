//
//  Extensions.swift
//  ios-model-kit
//
//  Created by Oleh Kulakevych on 03.05.2023.
//

import UIKit

extension UIViewController {

    static let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    func startLoading() {
        let activityIndicator = UIViewController.activityIndicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.medium
        DispatchQueue.main.async {
            self.view.addSubview(activityIndicator)
        }
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        let activityIndicator = UIViewController.activityIndicator
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
      }
}
