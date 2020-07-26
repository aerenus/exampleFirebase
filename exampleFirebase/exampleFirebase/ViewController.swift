//
//  ViewController.swift
//  exampleFirebase
//
//  Created by Eren FAIKOGLU on 19.07.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//
import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTxt.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }

    @IBAction func signInBtn(_ sender: Any) {
        if emailTxt.text != "" && passwordTxt.text != "" {
            Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text!) { (authdata, error) in
                if error != nil{
                 self.makeAlert(title: "Error", message: error!.localizedDescription)
                }
                else {
                    print("logged in.")
                    self.performSegue(withIdentifier: "toFeed", sender: nil)
                }
            }
        }
        else {
            makeAlert(title: "Error", message: "Email and password cannot be empty.")
        }
        
        //performSegue(withIdentifier: "toFeed", sender: nil)
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        print("btnok")
        if emailTxt.text != "" && passwordTxt.text != "" {
            Auth.auth().createUser(withEmail: emailTxt.text!, password: passwordTxt.text!) { (authData, error) in
                if error != nil {
                    self.makeAlert(title: "Error", message: error!.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "toFeed", sender: nil)
                }
            }
        } else {makeAlert(title: "Error", message: "Email and password cannot be empty.")}
    }
    
    func makeAlert(title : String, message : String){
    let alert = UIAlertController(title : title, message: message, preferredStyle: .alert)
    let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(okButton)
    self.present(alert, animated: true, completion: nil)
    }
}
