//
//  UIViewController+Additions.swift
//
//  Created by Prince on 2020-08-16.
//  Copyright © 2020 Prince. All rights reserved.
//

import UIKit

// MARK: - UIViewController Extension
extension UIViewController {

    /**
     Shows a simple alert view with a title and dismiss button

     - parameter title:   title for alerview
     - parameter message: message to be shown
     */
    func showAlertViewWithMessage(_ title: String?, message: String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    /**
     Shows a simple alert view with a title, dismiss button and action handler for dismiss button

     - parameter title:         title for alerview
     - parameter message:       message description
     - parameter actionHandler: actionHandler code/closer/block
     */
    func showAlertViewWithMessageAndActionHandler(_ title: String?, message: String, actionHandler: (() -> Void)?) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let alAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default) { _ in

            if let _ = actionHandler {
                actionHandler!()
            }
        }
        alertController.addAction(alAction)
        present(alertController, animated: true, completion: nil)
    }

}

