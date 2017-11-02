//
//  MessageTableViewCell.swift
//  Tricky
//
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
    @IBOutlet weak var lblTo : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func decorateTableViewCell(dictData : [String : AnyObject]) {
        print("")
//        self.lblMessage.text = (dictData["message"] as? String)?.replacingOccurrences(of: "+", with: " ")
        
        self.lblMessage.text = (dictData["message"] as? String)

        let date : Date = CommanUtility.convertAStringIntodDte(time : (dictData["time"] as? String)! , formate : "yyyy-MM-dd HH:mm:ss")
        
        self.lblTime.text = CommonUtil.timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        
        
        if let reveiverName = dictData["recieverName"] as? String {
            if (self.lblTo != nil)
            {
              //  self.lblTo.text = "To: \(reveiverName)"
            }
        }
        let isFavourite = dictData["isFavorite"] as! Bool
        if isFavourite {
          self.btnfavourite.isSelected = true
        }
        else
        {
        self.btnfavourite.isSelected = false
        }
        let isBlock = dictData["isUserBlock"] as! Bool
        if isBlock {
            self.btnBlock.isSelected = true
            self.btnReply.isHidden = true
        }
        else
        {
            self.btnReply.isHidden = false
            self.btnBlock.isSelected = false
        }
        
    }
    
}
