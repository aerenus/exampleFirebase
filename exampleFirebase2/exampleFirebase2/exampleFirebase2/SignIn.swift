//
//  ViewController.swift
//  exampleFirebase2
//
//  Created by Eren FAIKOGLU on 31.07.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit
import Firebase

class SignIn: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func signIn(_ sender: Any) {
        print("signInClick")
        if username.text != "" && password.text != "" {
            print("not empty")
            let fireStore = Firestore.firestore().collection("users").whereField("username", isEqualTo: username.text ?? "0")
            fireStore.addSnapshotListener { (QuerySnapshot, Error) in
                for doc in QuerySnapshot!.documents {
                 let userEmailFireBase = doc.get("email")
                    
                    if userEmailFireBase != nil {
                        print("email filled")
                        Auth.auth().signIn(withEmail: userEmailFireBase as! String, password: self.password.text!) { (AuthDataResult, Error) in
                            if Error != nil {
                                print("auth error")
                                self.showAlert(title: "Error", message: Error?.localizedDescription ?? "Unknown error while logging in.")
                            } else {
                                
                                print("signed in successfully.")
                                self.performSegue(withIdentifier: "signedIn", sender: nil)
                            }
                        }
                        
                        
                    } else {
                        self.showAlert(title: "Error", message: "Username not found.")
                    }
                    
                    
                }
            }
            
            
            
            
            
        } else {showAlert(title: "Warning", message: "Please fill all fields.")}
    }
    
    @IBAction func signUp(_ sender: Any) {
        print("to sign up...")
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        password.isSecureTextEntry = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

