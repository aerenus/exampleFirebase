//
//  thirdVC.swift
//  exampleFirebase
//
//  Created by Eren FAIKOGLU on 23.07.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit
import Firebase




class thirdVC: UIViewController {
    
    func makeLogOut() {
        do {
            print("trying logout")
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toFirst", sender: nil)
        }
        catch {
            print("Err!")
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logOutClicked(_ sender: Any) {
        makeLogOut()
        }
    

}
