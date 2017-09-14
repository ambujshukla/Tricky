//
//  CreateNewPostViewController.swift
//  Tricky
//
//  Created by gopal sara on 24/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import Localize_Swift

@objc protocol PostMessageDelegate{
    @objc optional func createNewPost()
}

class CreateNewPostViewController: UIViewController {

    @IBOutlet weak var btnCreate : UIButton!
    @IBOutlet weak var txtViewComment : UITextView!
    @IBOutlet weak var imgBg : UIImageView!
    var delegate:PostMessageDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
         self.decorateUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func decorateUI () {
        self.imgBg.image = UIImage(named : MESSAGE_SEND_BG)
        self.btnCreate.layer.borderColor = UIColor.white.cgColor
        self.btnCreate.layer.borderWidth = 1.0
        self.btnCreate.layer.masksToBounds = true
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "John smith", strBackButtonImage: BACK_BUTTON, selector: #selector(self.goTOBack), color: color(red: 147, green: 108, blue: 234))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 147, green: 108, blue: 234)
    }
    
    func goTOBack()
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func doClickSend()
    {
        guard let text = self.txtViewComment.text, !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            CommonUtil.showTotstOnWindow(strMessgae: "txt_please_enter_post".localized())
            return
        }
        
            let params = ["userId" : "19","postMessage" : self.txtViewComment.text, "postAsAnonomous" : "0", "version" : "1.0", "os" : "iOS", "language" : "English"] as [String : Any]
            WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "CreatePost", parameter: params, success: { (responseObject) in
                print(responseObject)
                if responseObject["status"] as! String == "1"
                {
                  self.txtViewComment.text = ""
                    CommonUtil.showTotstOnWindow(strMessgae: "txt_success_post".localized())
                    self.delegate?.createNewPost!()
                }else
                {
                
                }
            }) { (error) in
                print(error as! NSError)
            }
    }

}
