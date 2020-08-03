//
//  Interactions.swift
//  exampleFirebase2
//
//  Created by Eren FAIKOGLU on 01.08.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit
import MapKit

extension UIViewController {
  func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message:
      message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
    }))
    self.present(alertController, animated: true, completion: nil)
  }
    
    func showInfo(title: String, message: String) {
      let alertController = UIAlertController(title: title, message:
        message, preferredStyle: .alert)
      self.present(alertController, animated: true, completion: nil)
    }
    
     func distanceC2c(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}
