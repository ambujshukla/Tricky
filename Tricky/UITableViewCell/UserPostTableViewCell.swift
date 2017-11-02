//
//  UserPostTableViewCell.swift
//  Tricky
//
//

import UIKit

class UserPostTableViewCell: UITableViewCell {

    @IBOutlet weak var btnAnswer : UIButton!
    @IBOutlet weak var lblMessage : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
