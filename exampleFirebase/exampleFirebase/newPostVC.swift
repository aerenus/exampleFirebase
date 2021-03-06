//
//  newPostVC.swift
//  exampleFirebase
//
//  Created by Eren FAIKOGLU on 23.07.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit
import Firebase

class newPostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var imageDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        image.isUserInteractionEnabled = true
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        image.addGestureRecognizer(imageTap)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    @IBAction func uploadBtn(_ sender: Any) {
        //let storage = Storage
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        let mediaFolder = storageReferance.child("media")
        
        if let data = image.image?.jpegData(compressionQuality: 0.2) {
            let ImageUUID = UUID().uuidString
            let imageReferance = mediaFolder.child("\(ImageUUID).jpg")
            let alert = UIAlertController.init(title: "Please wait.", message: "File upload in progress", preferredStyle: .alert)
            present(alert, animated: true)
            imageReferance.putData(data, metadata: nil) { (metadata, errorPut) in
                if errorPut != nil {
                    alert.dismiss(animated: false, completion: nil)
                    print(errorPut?.localizedDescription ?? "Error.")
                    let alertErr = UIAlertController(title: "Error", message: errorPut?.localizedDescription, preferredStyle: .alert)
                    let button = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                    alertErr.addAction(button)
                    self.present(alertErr, animated: true)
                } else {
                        alert.dismiss(animated: true, completion: nil)
                        imageReferance.downloadURL { (url, error) in
                        if error == nil {
                            let imgURL = url?.absoluteString
                            print(imgURL ?? "IMGURL VAL")
                            
                            
                            
                            let fireStoreDB = Firestore.firestore()
                            var fireStoreRef : DocumentReference? = nil
                            let userID = Auth.auth().currentUser!.uid
                            
                            let fireStorePost = [
                                "imageURL" : imgURL!,
                                "postedBy" : Auth.auth().currentUser!.email!,
                                "postDesc" : self.desc.text ?? "",
                                "date" : FieldValue.serverTimestamp(),
                                "like" : 0,
                                ] as [String : Any]
                            
                            fireStoreRef = fireStoreDB.collection("Posts").addDocument(data: fireStorePost, completion: { (errorPost) in
                                if errorPost != nil {
                                    print(errorPost?.localizedDescription ?? "ERR VAL")
                                } else {
                                    print("New post created, user id \(userID)")
                                    //tabbar ile calisiyorsak tabbarcontroller ile yoksa segue
                                    //self.performSegue(withIdentifier: "newPostAdded", sender: nil)
                                    
                                    self.image.image = UIImage(systemName: "square.and.arrow.up.fill")
                                    self.desc.text = ""
                                    self.imageDesc.text = "Please select an image"
                                    self.imageDesc.font = UIFont(name: "System", size: 20)
                                    
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                            
                            
                        } else {
                            print(error?.localizedDescription ?? "ERR VAL")
                            }
                    }
                }
            }
            
        }
    
    }
    
    @objc func imageTapped(){
        print("gesture ok")
        let picker = UIImagePickerController()
        picker.delegate = self
        
        //.camera doesnt works on simulator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        imageDesc.text = "You can change image by clicking to image"
        imageDesc.font = UIFont(name: "System", size: 17)
    }
    
}
