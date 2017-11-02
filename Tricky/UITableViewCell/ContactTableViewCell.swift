//
//  ContactTableViewCell.swift
//  Tricky
//
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblNumber : UILabel!
    @IBOutlet weak var btnBlockOrInvite : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBlockContactListData(dictData : [String : AnyObject]) {
        self.lblName?.text = dictData["userName"] as? String
        self.lblNumber?.text = dictData["userNumber"] as? String
        self.btnBlockOrInvite.setImage(#imageLiteral(resourceName: "blockselecticon"), for: .normal)
        self.btnBlockOrInvite.isSelected = true
    }
    
    func setCompleteContactListDataOn(dictData : [String : AnyObject]){
        
        self.lblName?.text = dictData["userName"] as? String
        self.lblNumber?.text = dictData["userNumber"] as? String
        let isOnApp = dictData["isOnApp"] as! Bool
        if isOnApp {
            self.btnBlockOrInvite.setImage(#imageLiteral(resourceName: "unblock_user_icon"), for: .normal)
        }
        else
        { //shareicon
            self.btnBlockOrInvite.setImage(#imageLiteral(resourceName: "shareicon"), for: .normal)
        }
        self.btnBlockOrInvite.isSelected = false

    }
    
    func setAppUserContactListData(dictData : [String : AnyObject]){
        self.lblName?.text = dictData["userName"] as? String
        self.lblNumber?.text = dictData["userNumber"] as? String
        self.btnBlockOrInvite.isHidden = true
    }
    
    

}
