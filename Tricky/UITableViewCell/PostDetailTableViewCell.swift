//
//  PostDetailTableViewCell.swift
//  Tricky
//
//  Created by Shweta Shukla on 03/09/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit

class PostDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var lblPost : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var view : UIView!
    @IBOutlet weak var btnOptions : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.layer.cornerRadius = 5.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
