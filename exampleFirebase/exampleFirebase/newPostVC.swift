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
        
        if let data = image.image?.jpegData(compressionQuality: 0.5) {
            let ImageUUID = UUID().uuidString
            let imageReferance = mediaFolder.child("\(ImageUUID).jpg")
            let alert = UIAlertController.init(title: "Please wait.", message: "File upload in progress", preferredStyle: .alert)
            present(alert, animated: true)
            imageReferance.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "Error.")
                    
                } else {
                        alert.dismiss(animated: true, completion: nil)
                        imageReferance.downloadURL { (url, error) in
                        if error != nil {
                            let imgURL = url?.absoluteString
                            print(imgURL ?? "IMGURL VAL")
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
