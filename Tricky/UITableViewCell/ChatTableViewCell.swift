//
//  ChatTableViewCell.swift
//  Tricky
//
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var view : UIView!
    @IBOutlet weak var imgBG : UIImageView!
    @IBOutlet weak var btnSend : UIButton!
    @IBOutlet weak var lblTime : UILabel!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.lblMessage.textColor = UIColor.black
        self.imgBG.layer.cornerRadius = 5.0
      //  self.imgBG.backgroundColor = UIColor.lightGray
       // self.btnSend.setImage(UIImage(named : ""), for: .normal)
    }
}
