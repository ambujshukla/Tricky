//
//  UserPostAnswerViewController
//  OTPSection
//
//  Created by gopalsara on 24/08/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//

import UIKit
import Localize_Swift
import ObjectMapper
class UserPostAnswerViewController: UIViewController {
    
    @IBOutlet weak var txtViewComment : UITextView!
    @IBOutlet weak var btnSend : UIButton!
    @IBOutlet weak var lblHeader : UILabel!
    @IBOutlet weak var lblLeaveAnswer : UILabel!
    @IBOutlet weak var imgBG : UIImageView!
    var strUserId : String = ""
    var strTitle : String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
    }
    
    func decorateUI ()
    {
        //  self.btnSend.layer.borderColor = UIColor.white.cgColor
        //  self.btnSend.layer.borderWidth = 1.0
        //  self.btnSend.layer.masksToBounds = true
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: strTitle , strBackButtonImage: BACK_BUTTON, selector: #selector(self.goTOBack), color: color(red: 146, green: 102, blue: 236))
        
        //      self.txtViewComment.backgroundColor = color(red: 219, green: 192, blue: 177)
        //    self.lblHeader.text = "Non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam voluptatem. Ut enim ad minima tempora incidunt veniam"
        //   self.lblLeaveAnswer.text = "txt_leave_answer".localized()
        //    self.lblHeader.textColor = UIColor.white
        
        self.imgBG.image = UIImage(named : MESSAGE_SEND_BG)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 146, green: 102, blue: 236)
    }
    
    func goTOBack()
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    func doCallServiceForSendMessgae() {
        
        let dictData = ["version" : "1.0" , "type" : "1"  , "message": self.txtViewComment.text!  , "userId" : "19","receiverId" : self.strUserId] as [String : Any]
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "sendMessage", parameter: dictData , success: { (obj) in
            
            print(obj)
            let sendMessageData  = Mapper<SendMessageModel>().map(JSON: obj)
            
            if sendMessageData?.status == "1"
            {
                CommonUtil.showTotstOnWindow(strMessgae: (sendMessageData?.responseMessage)!)
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                CommonUtil.showTotstOnWindow(strMessgae: (sendMessageData?.responseMessage)!)
            }
            
            print("this is object \(obj)")
        }) { (error) in
            CommonUtil.showTotstOnWindow(strMessgae: (error?.localizedDescription)!)
            
        }
        
        
    }
    
    @IBAction func doClickSend()
    {
        self.doCallServiceForSendMessgae()
        
        // let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        // self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
