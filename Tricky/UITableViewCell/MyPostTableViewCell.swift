//
//  MyPostTableViewCell.swift
//  Tricky
//
//  Created by gopalsara on 23/09/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit

class MyPostTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var view : UIView!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnDelete : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func decorateTableView(dictData : [String : AnyObject])
    {
        self.lblMessage.text = dictData["message"]! as? String
        self.lblTime.text = CommanUtility.doChangeTimeFormat(time: (dictData["time"] as? String)!, firstFormat: "yyyy-MM-dd HH:mm:ss", SecondFormat: "dd-MM-YYYY")
    }


}
