//
//  UIViewController + Spinner.swift
//  Shopify-S19
//
//  Created by Neelaksh Bhatia on 2019-01-20.
//  Copyright © 2019 Neelaksh Bhatia. All rights reserved.
//

import UIKit

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = .white
        let ai = UIActivityIndicatorView.init(style: .gray)
        ai.startAnimating()
        ai.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }

        return spinnerView
    }

    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
