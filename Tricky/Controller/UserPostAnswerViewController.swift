//
//  UserPostAnswerViewController
//  OTPSection
//
//  Created by gopalsara on 24/08/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//

import UIKit
import Localize_Swift

class UserPostAnswerViewController: UIViewController {
    
    @IBOutlet weak var txtViewComment : UITextView!
    @IBOutlet weak var btnSend : UIButton!
    @IBOutlet weak var lblHeader : UILabel!
    @IBOutlet weak var lblLeaveAnswer : UILabel!
    @IBOutlet weak var imgBG : UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
    }
    
    func decorateUI ()
    {
        self.btnSend.layer.borderColor = UIColor.white.cgColor
        self.btnSend.layer.borderWidth = 1.0
        self.btnSend.layer.masksToBounds = true
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "John smith", strBackButtonImage: BACK_BUTTON, selector: #selector(self.goTOBack), color: color(red: 147, green: 108, blue: 234))
        
        self.txtViewComment.backgroundColor = color(red: 219, green: 192, blue: 177)
        self.lblHeader.text = "Non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam voluptatem. Ut enim ad minima tempora incidunt veniam"
        self.lblLeaveAnswer.text = "txt_leave_answer".localized()
        self.lblHeader.textColor = UIColor.white
        
        self.imgBG.image = UIImage(named : MESSAGE_SEND_BG)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 214, green: 162, blue: 132)
    }
    
    func goTOBack()
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func doClickSend()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
