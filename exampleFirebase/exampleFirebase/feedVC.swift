//
//  feedVC.swift
//  exampleFirebase
//
//  Created by Eren FAIKOGLU on 23.07.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage



class feedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var postIDArray = [String]()
    var imageURLArray = [String]()
    var likeArray = [Int]()
    var postDescArray = [String]()
    var postedByArray = [String]()
    var dateArray = [Date]()
    
    var selectedImg = ""
    var selectedPostDesc = ""
    var selectedLike = ""
    var selectedPostedBy : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postIDArray.removeAll()
        self.imageURLArray.removeAll()
        self.likeArray.removeAll()
        self.postDescArray.removeAll()
        self.postedByArray.removeAll()
        self.dateArray.removeAll()
        
        tableView.delegate = self
        tableView.dataSource = self 
        // Do any additional setup after loading the view.
        getData()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.postIDArray.removeAll()
        self.imageURLArray.removeAll()
        self.likeArray.removeAll()
        self.postDescArray.removeAll()
        self.postedByArray.removeAll()
        self.dateArray.removeAll()
        getData()
        tableView.reloadData()
    }
        
    func getData() {
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (addSnpBlock, snpError) in
            if snpError != nil {
                print(snpError?.localizedDescription ?? "Error")
            } else {
                print("SnpBlck No ERR")
                
                self.postIDArray.removeAll()
                self.imageURLArray.removeAll()
                self.likeArray.removeAll()
                self.postDescArray.removeAll()
                self.postedByArray.removeAll()
                self.dateArray.removeAll()
                
                
                for doc in addSnpBlock!.documents {
                    

                    
                    
                    //let docID = doc.documentID
                    //print(docID)
                    let docID = doc.documentID
                    self.postIDArray.append(docID)
                    print("\(self.postIDArray.count). element started to add.")
                    
                    
                    if let postedBy = doc.get("postedBy") as? String{
                        self.postedByArray.append(postedBy)
                    }
                    
                    if let postDesc = doc.get("postDesc") as? String{
                        self.postDescArray.append(postDesc)
                    }
                    
                    if let like = doc.get("like") as? Int{
                        self.likeArray.append(like)
                    }
                    
                    if let imageURL = doc.get("imageURL") as? String{
                        self.imageURLArray.append(imageURL)
                    }
                    
                    if let date = doc.get("date") as? Date{
                        self.dateArray.append(date)
                    }
                    
                    
            }
                self.tableView.reloadData()
        }
    }
                    
}

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countCnt:Int? =  postIDArray.count
        return countCnt ?? 0
        //return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! cellTableViewCell
        cell.self.postImg.image = UIImage(systemName: "nosign")
        //cell.postDate.text = Date(dateArray[indexPath.row])
        cell.postDesc.text = postDescArray[indexPath.row]
        cell.postLikeCount.text = String(likeArray[indexPath.row])
        cell.userName.text = postedByArray[indexPath.row]
        cell.postID.text = postIDArray[indexPath.row]
        cell.postImg.sd_setImage(with: URL(string: imageURLArray[indexPath.row]))
        
        return cell
    }
    
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedImg = imageURLArray[indexPath.row]
       // var selectedPostDesc = postDescArray[indexPath.row]
       // var selectedLike = likeArray[indexPath.row]
        selectedPostedBy = postedByArray[indexPath.row]
        
        performSegue(withIdentifier: "imgDet", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "imgDet"{
            let destinationVC = segue.destination as! imgDet
            destinationVC.imageelemfull = selectedImg
            destinationVC.postedbyelemfull = selectedPostedBy
        }
    }
    
    
    
    



}
