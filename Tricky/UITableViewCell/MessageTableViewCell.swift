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
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var btnfavourite : UIButton!
    @IBOutlet weak var btnReply : UIButton!
    @IBOutlet weak var btnBlock : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnDelete : UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func decorateTableViewCell(dictData : [String : AnyObject]) {
        print("")
        self.lblMessage.text = dictData["message"] as? String
        self.lblTime.text =  CommanUtility.doChangeTimeFormat(time: (dictData["time"] as? String)!, firstFormat: "yyyy-MM-dd HH:mm:ss", SecondFormat: "HH:mm")
        //2017-09-05 19:35:30,
        //dictData["time"] as? String
    }
    
}
