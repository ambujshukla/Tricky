//
//  PostTableViewCell.swift
//  Tricky
//
//  Created by gopal sara on 25/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var btnOptions : UIButton!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var view : UIView!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnReply : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.layer.cornerRadius = 5.0
        // Initialization code
    }

    func decorateTableView(dictData : [String : AnyObject])
    {
      self.lblMessage.text = dictData["message"]! as? String
      self.lblTime.text = CommanUtility.doChangeTimeFormat(time: (dictData["time"] as? String)!, firstFormat: "yyyy-MM-dd HH:mm:ss", SecondFormat: "HH:mm")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
