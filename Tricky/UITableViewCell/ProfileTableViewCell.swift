//
//  ProfileTableViewCell.swift
//  Tricky
//
//  Created by gopalsara on 19/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var txtField : UITextField!
    @IBOutlet weak var txtCountryCode : UITextField!
    @IBOutlet weak var btnSave : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnSave?.setTitle("txt_save".localized(), for: .normal)
        self.btnSave?.setTitleColor(UIColor.white, for: .normal)
        self.btnSave?.layer.borderColor = UIColor.white.cgColor
        self.btnSave?.backgroundColor = UIColor.clear
        self.btnSave?.layer.borderWidth = 1.0
        
        self.txtField?.textColor = UIColor.white
        self.txtCountryCode?.textColor = UIColor.white
    }

    

}
