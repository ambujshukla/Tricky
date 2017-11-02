//
//  ChatListCell.swift
//  Tricky
//
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
    
    func doSetDataOnCell(dictData : [String : AnyObject]){
        
        if let value = dictData["chatMessage"] as? String {
            self.lblName.text = (value ).removingPercentEncoding
        }
        if let message = dictData["recentMessage"] as? String {
            self.lblMessage.text = message.removingPercentEncoding

        }
        if let time = dictData["recentMessageTime"] as? String {
            
            let date : Date = CommanUtility.convertAStringIntodDte(time : (time) , formate : "yyyy-MM-dd HH:mm:ss")
            self.lblTime.text = CommonUtil.timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        }
    }
}
