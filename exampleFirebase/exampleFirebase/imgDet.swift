//
//  imgDet.swift
//  exampleFirebase
//
//  Created by Eren FAIKOGLU on 26.07.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class imgDet: UIViewController {

    @IBOutlet weak var imageFull: UIImageView!
    
    @IBOutlet weak var postedByFull: UILabel!
    
    var postedbyelemfull : String =  ""
    var imageelemfull : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        postedByFull.text = postedbyelemfull
        imageFull.sd_setImage(with: URL(string: imageelemfull))
        //imageFull.image = UIImage()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
