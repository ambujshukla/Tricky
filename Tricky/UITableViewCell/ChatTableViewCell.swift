//
//  ChatTableViewCell.swift
//  Tricky
//
//  Created by Shweta Shukla on 20/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var view : UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.lblDate.textColor = UIColor.white
        self.lblMessage.textColor = UIColor.white
        self.view.layer.cornerRadius = 5.0
        // Initialization code
    }
}
