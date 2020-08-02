//
//  Interactions.swift
//  exampleFirebase2
//
//  Created by Eren FAIKOGLU on 01.08.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit

extension UIViewController {
  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message:
      message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
    }))
    self.present(alertController, animated: true, completion: nil)
  }
}
