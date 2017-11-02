//
//  BlockUserListTableViewCell.swift
//  Tricky
//
//

import UIKit

class BlockUserListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var imgBlock : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lblTitle.textColor = UIColor.white
        self.imgBlock.image = UIImage(named : BLOCK_ICON)
        // Initialization code
    }
}
