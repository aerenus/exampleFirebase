//
//  feedVC.swift
//  exampleFirebase
//
//  Created by Eren FAIKOGLU on 23.07.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit

class feedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self 
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellTableViewCell
        cell.postImg.image = UIImage(systemName: "nosign")
        cell.postDate.text = "No data"
        cell.postDesc.text = "No data"
        cell.postLikeCount.text = "0"
        cell.userName.text = "No data"
        
        return cell
    }

}
