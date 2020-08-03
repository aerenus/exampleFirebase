//
//  settings.swift
//  exampleFirebase2
//
//  Created by Eren FAIKOGLU on 02.08.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit
import Firebase


class settings: UIViewController {
    
    
    @IBOutlet weak var usernameHead: UILabel!
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var userid: UILabel!
    
    @IBOutlet weak var date: UILabel!
    
    var fireBaseData : [String : Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let emailIns = Auth.auth().currentUser!.email
        let useridIns = Auth.auth().currentUser!.uid
        let dateIns = "08.2020"
        
        email.text = emailIns
        userid.text = useridIns
        date.text = dateIns
        
        
        let fireStore = Firestore.firestore().collection("users").whereField("uid", isEqualTo: useridIns)
        fireStore.addSnapshotListener { (QuerySnapshot, Error) in
            for doc in QuerySnapshot!.documents {
             let userNameFireBase = doc.get("username")
                self.username.text = userNameFireBase as? String
                self.usernameHead.text = userNameFireBase as? String
                print(userNameFireBase ?? "N/A")
            }
        }
        
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func logout(_ sender: Any) {
        do {  try Auth.auth().signOut()
            
            //feed view controller adi
            let secondVC = storyboard?.instantiateViewController(withIdentifier: "signin") as! SignIn
            secondVC.modalPresentationStyle = .fullScreen
            self.present(secondVC, animated:true, completion:nil)
            
        }
        catch {showAlert(title: "Error", message: "Service returned an error while make sign out process.")}
    }
    
}
