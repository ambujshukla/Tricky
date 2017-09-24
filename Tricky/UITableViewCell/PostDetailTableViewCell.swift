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
    @IBOutlet weak var btnReply : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var btnDelete : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.view.layer.cornerRadius = 5.0
        // Initialization code
    }

    func decorateTableView(dictData : [String : AnyObject])
    {
        self.lblPost.text = dictData["message"]! as? String
        self.lblDate.text = CommanUtility.doChangeTimeFormat(time: (dictData["time"] as? String)!, firstFormat: "yyyy-MM-dd HH:mm:ss", SecondFormat: "hh:mm a dd-MMM-YYYY")
    }

}
