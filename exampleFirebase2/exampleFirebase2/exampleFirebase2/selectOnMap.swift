//
//  selectOnMap.swift
//  exampleFirebase2
//
//  Created by Eren FAIKOGLU on 02.08.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class selectOnMap: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var selectedLat = 0.0
    var selectedLong = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.isUserInteractionEnabled = true
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         let locationMK = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
         let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
         let region = MKCoordinateRegion(center: locationMK, span: span)
         mapView.setRegion(region, animated: true)
     }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    
    @objc func chooseLocation(gestureRecognizer:UILongPressGestureRecognizer){
        
        print("\(gestureRecognizer.minimumPressDuration) sec pressed.")
        if gestureRecognizer.state == .began {
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            selectedLat = touchedCoordinates.latitude
            selectedLong = touchedCoordinates.longitude
            
            //tick on map
            let tick = MKPointAnnotation()
            tick.coordinate = touchedCoordinates
            tick.title = "Point"
            tick.subtitle = "You selected this point. You can change the point by pressing another place."
            self.mapView.removeAnnotations(mapView.annotations)
            self.mapView.addAnnotation(tick)
            
            
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        //performSegue(withIdentifier: "newPost", sender: nil)
        
        let newPost = storyboard?.instantiateViewController(withIdentifier: "newPost") as! newPost
        newPost.chosenLat = selectedLat
        newPost.chosenLong = selectedLong
        
        //ios 13 ile geldi
        newPost.modalPresentationStyle = .fullScreen
        self.present(newPost, animated:true, completion:nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newPost"{
            let targetVC = segue.destination as! newPost
            targetVC.chosenLat = selectedLat
            targetVC.chosenLong = selectedLong
            
        }
    }
    
}
