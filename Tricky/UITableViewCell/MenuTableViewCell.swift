//
//  MenuTableViewCell.swift
//  Tricky
//
//

import UIKit
import PWSwitch

class MenuTableViewCell: UITableViewCell
{
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var switchPW : PWSwitch!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.switchPW?.thumbOnFillColor = color(red: 193, green: 26, blue: 92)
       self.switchPW?.thumbOffFillColor = color(red: 128, green: 128, blue: 128)
       self.switchPW?.trackOffFillColor = color(red: 204, green: 204, blue: 204)
       self.switchPW?.trackOnBorderColor = color(red: 204, green: 204, blue: 204)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
