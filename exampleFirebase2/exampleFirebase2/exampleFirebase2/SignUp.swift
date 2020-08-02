//
//  SignUp.swift
//  exampleFirebase2
//
//  Created by Eren FAIKOGLU on 01.08.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SignUp: UIViewController {


    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    @IBAction func signUp(_ sender: Any) {
        if username.text != "" && email.text != "" && password.text != ""  {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (AuthDataResult, Error) in
                if Error == nil {
                    
                    let signedUpUserName = self.username.text!
                    let signedUpUserEmail = Auth.auth().currentUser?.email
                    let signedUpUserUid = Auth.auth().currentUser?.uid

                    let fireStore = Firestore.firestore()
                    let dataToInsert = ["email" : signedUpUserEmail, "uid" : signedUpUserUid, "username" : signedUpUserName] as [String : Any]
                    
                    fireStore.collection("users").addDocument(data: dataToInsert) { (Error) in
                        if Error == nil {
                            print("user created. fireStore inserted. take me to the feed.")
                            self.performSegue(withIdentifier: "signedUp", sender: nil)
                        }
                        
                    }
                    

                } else {
                    self.showAlert(title: "Error", message: Error?.localizedDescription ?? "Service Error. Please try again.")
                }
            }
        }
        else {showAlert(title: "Warning", message: "Please fill all fields.")}
    }
    
    @IBAction func backToSignIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
