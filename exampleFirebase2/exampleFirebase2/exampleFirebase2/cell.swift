//
//  cell.swift
//  exampleFirebase2
//
//  Created by Eren FAIKOGLU on 02.08.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class cell: UITableViewCell, MKMapViewDelegate {

    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeMap: MKMapView!
    @IBOutlet weak var placeRate: UILabel!
    @IBOutlet weak var placeDistance: UILabel!
    @IBOutlet weak var placeNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        placeMap.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
