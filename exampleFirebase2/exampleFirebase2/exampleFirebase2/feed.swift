//
//  feed.swift
//  exampleFirebase2
//
//  Created by Eren FAIKOGLU on 02.08.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import SDWebImage

class feed: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    var cellArray = [cellModel]()
    var locationManager = CLLocationManager()
    var locationCurrent = CLLocationCoordinate2D()

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        getData()     
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            locationCurrent = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
     }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func getData(){
        cellArray.removeAll(keepingCapacity: false)
        let fireDB = Firestore.firestore()
        fireDB.collection("posts").addSnapshotListener { (QuerySnapshot, Error) in
            if Error != nil {
                self.showAlert(title: "Error", message: Error?.localizedDescription ?? "Unknown error.")
            } else {
                
                for doc in QuerySnapshot!.documents{
                    
                    let docID = doc.documentID
                    let data = cellModel(docID: docID,
                                         descriptionModel: doc.get("description") as! String,
                                         imageModel: doc.get("image") as! String,
                                         latModel: doc.get("lat") as! Double,
                                         longModel: doc.get("long") as! Double,
                                         rateModel: doc.get("rate") as! Double,
                                         senderModel: doc.get("sender") as! String)
                    
                    self.cellArray.append(data)
                }
                
               
                
            }
             self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countArr:Int? = cellArray.count
        print("\(countArr ?? 0) rows returned.")
        return countArr ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cell
        let rowNumber = indexPath.row+1
        
        cell.placeImage.sd_setImage(with: URL(string: cellArray[indexPath.row].imageModel))
        cell.placeName.text = cellArray[indexPath.row].descriptionModel
        cell.placeRate.text = String(format: "%3.f",cellArray[indexPath.row].rateModel)
        
        let locationMK = CLLocationCoordinate2D(latitude: cellArray[indexPath.row].latModel, longitude: cellArray[indexPath.row].longModel)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locationMK, span: span)
        let placeDistance = String(Int(distanceC2c(from: locationMK, to: locationCurrent)))
        
        cell.placeMap.setRegion(region, animated: true)
        cell.placeDistance.text = "\(placeDistance) meters to go"
        cell.placeNumber.text = String(rowNumber)
            
            //tick on map
            let tick = MKPointAnnotation()
            tick.coordinate = CLLocationCoordinate2D(latitude: cellArray[indexPath.row].latModel, longitude: cellArray[indexPath.row].longModel)
            tick.title = cellArray[indexPath.row].descriptionModel
            cell.placeMap.removeAnnotations(cell.placeMap.annotations)
            cell.placeMap.addAnnotation(tick)

            //cell.placeDistance.text = Int(format: "%2.f",distanceC2c(from: locationMK, to: locationCurrent))
        
        return cell
    }
    


}
