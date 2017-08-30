//
//  UserPostTableViewCell.swift
//  Tricky
//
//  Created by gopal sara on 25/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit

class UserPostTableViewCell: UITableViewCell {

    @IBOutlet weak var btnAnswer : UIButton!
    @IBOutlet weak var lblMessage : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
