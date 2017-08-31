//
//  ChatTableViewCell.swift
//  Tricky
//
//  Created by gopalsara on 20/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var view : UIView!
    @IBOutlet weak var imgBG : UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.lblDate.textColor = UIColor.white
        self.lblMessage.textColor = UIColor.white
        self.imgBG.layer.cornerRadius = 5.0
        self.imgBG.backgroundColor = UIColor.lightGray
    }
}
