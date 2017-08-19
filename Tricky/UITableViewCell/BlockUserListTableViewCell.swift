//
//  BlockUserListTableViewCell.swift
//  Tricky
//
//  Created by Shweta Shukla on 20/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit

class BlockUserListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var imgBlock : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle.textColor = UIColor.white
        self.imgBlock.backgroundColor = UIColor.red
        // Initialization code
    }
}
