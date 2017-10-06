//
//  ChatListCell.swift
//  Tricky
//
//  Created by gopal sara on 08/09/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
class ChatListCell: UITableViewCell {
    
    @IBOutlet weak var btnDelete : UIButton!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func doSetDataOnCell(dictData : Dictionary<String, Any>){
        
        if let value = dictData["name"] as? String {
            self.lblName.text = (value )
        }
        if let message = dictData["recentMessage"] as? String {
            self.lblMessage.text = (message )
        }
        if let time = dictData["recentMessageTime"] as? String {
            self.lblTime.text = (time )
        }
    }
}
