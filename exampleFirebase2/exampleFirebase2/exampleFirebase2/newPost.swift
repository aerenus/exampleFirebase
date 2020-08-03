//
//  newPost.swift
//  exampleFirebase2
//
//  Created by Eren FAIKOGLU on 02.08.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

class newPost: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var desc: UITextField!
    
    @IBOutlet weak var location: MKMapView!
    
    var gpsData = 0.0000000
    var locationManager = CLLocationManager()
    var chosenLat = 0.0
    var chosenLong = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image.isUserInteractionEnabled = true
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        image.addGestureRecognizer(imageTap)
        
        
        location.isUserInteractionEnabled = true
        let mapTap = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        location.addGestureRecognizer(mapTap)
        
        location.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(chosenLat)
        print(chosenLong)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if chosenLat == 0.0 && chosenLong == 0.0 {
        let locationMK = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locationMK, span: span)
        location.setRegion(region, animated: true)
        } else {
        let locationMK = CLLocationCoordinate2D(latitude: chosenLat, longitude: chosenLong)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locationMK, span: span)
        location.setRegion(region, animated: true)
            
            //tick on map
            let tick = MKPointAnnotation()
            tick.coordinate = CLLocationCoordinate2D(latitude: chosenLat, longitude: chosenLong)
            tick.title = "Selected point"
            tick.subtitle = "You selected this point. You can change the point by pressing to map area."
            self.location.removeAnnotations(location.annotations)
            self.location.addAnnotation(tick)
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    

    @objc func imageTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    @objc func mapTapped() {
        //selectOnMap view controller adi
        let secondVC = storyboard?.instantiateViewController(withIdentifier: "selectOnMap") as! selectOnMap
        self.present(secondVC, animated:true, completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func fullView(_ sender: Any) {
    }
    
    @IBAction func rate(_ sender: UISlider) {
        gpsData = Double(sender.value)
        print(sender.value)
        
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        if desc.text != "" {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let folder = storageRef.child("media")
        
        //take selected img
        if let imagedata = image.image?.jpegData(compressionQuality: 0.2){
            //upload
            let imageUUID = UUID().uuidString
            let imageRef = folder.child("\(imageUUID).jpg")
            //wait info
            showInfo(title: "Please wait...", message: "File upload in progress... This may take up to 30 seconds.")
            
            imageRef.putData(imagedata, metadata: nil) { (StorageMetadata, ErrorPut) in
                if ErrorPut != nil {
                    self.dismiss(animated: true, completion: nil)
                    self.showAlert(title: "Error", message: ErrorPut?.localizedDescription ?? "Unknown error from service side.")
                } else {
                    self.dismiss(animated: true, completion: nil)
                    imageRef.downloadURL { (URL, ErrorURL) in
                        if ErrorURL == nil {

                            
                            let FireStoreDB = Firestore.firestore()
                            var fireStoreref : DocumentReference? = nil
                            
                            let postimgURL = URL?.absoluteString
                            let postDescription = self.desc.text
                            let postGps = ""
                            let postRate = self.gpsData
                            let postSender = Auth.auth().currentUser?.email
                            
                            let postData = [
                                "image": postimgURL,
                                "description": postDescription,
                                "lat": self.chosenLat,
                                "long": self.chosenLong,
                                "rate": postRate,
                                "sender": postSender
                            ] as [String : Any]
                                
                            fireStoreref = FireStoreDB.collection("posts").addDocument(data: postData, completion: { (Error) in
                                if Error != nil {
                                    self.showAlert(title: "Error", message: Error?.localizedDescription ?? "Unknown error from service side.")
                                } else {
                                    print("Posted.")
                                    self.image.image = UIImage(systemName: "photo")
                                    self.desc.text = ""
                                    self.location.removeAnnotations(self.location.annotations)
                                    
                                    
                                    let board = UIStoryboard(name: "Main", bundle: nil)
                                    let tabbar = board.instantiateViewController(identifier: "feedID") as! UITabBarController
                                    tabbar.modalPresentationStyle = .fullScreen
                                    self.present(tabbar, animated:true, completion:nil)
                                }
                            })
                            
                            
                            
                        } else
                        {
                            print("Image Ref error.\(ErrorURL?.localizedDescription ?? "Unknown error from service side.")")
                            
                        }
                    }
                }
            }
        
        
        
    }
    
}
    }
    @IBAction func backFeed(_ sender: Any) {
                                         let board = UIStoryboard(name: "Main", bundle: nil)
        let tabbar = board.instantiateViewController(identifier: "feedID") as! UITabBarController
        tabbar.modalPresentationStyle = .fullScreen
        self.present(tabbar, animated:true, completion:nil)
    }
}
