//
//  MessageTableViewCell.swift
//  Tricky
//
//  Created by gopal sara on 22/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var btnfavourite : UIButton!
    @IBOutlet weak var btnReply : UIButton!
    @IBOutlet weak var btnBlock : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnDelete : UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
