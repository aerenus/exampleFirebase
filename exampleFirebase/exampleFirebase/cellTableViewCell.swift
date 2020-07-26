//
//  cellTableViewCell.swift
//  exampleFirebase
//
//  Created by Eren FAIKOGLU on 26.07.2020.
//  Copyright © 2020 Eren FAIKOGLU. All rights reserved.
//

import UIKit

class cellTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var postImg: UIImageView!
    
    @IBOutlet weak var postDesc: UILabel!
    
    @IBOutlet weak var postLikeCount: UILabel!
    
    @IBOutlet weak var postDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeBtn(_ sender: Any) {
    }
}
