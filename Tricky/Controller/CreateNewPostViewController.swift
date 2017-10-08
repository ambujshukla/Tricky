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

class CreateNewPostViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var btnCreate : UIButton!
    @IBOutlet weak var txtViewComment : UITextView!
    @IBOutlet weak var imgBg : UIImageView!
    var delegate:PostMessageDelegate?
    var isPostReply : Bool = false
    var strPostID : String!
    @IBOutlet weak var lblReply : UILabel!
    @IBOutlet weak var btnAnonymous : UIButton!
    @IBOutlet weak var lblAnonymoust : UILabel!
    @IBOutlet weak var lblCharacter : UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func decorateUI () {
        
        self.lblCharacter.text = "160"
        self.lblCharacter.textColor = UIColor.white
        self.txtViewComment.delegate = self
        self.lblAnonymoust.text = "Post as anonymous".localized()
        self.btnAnonymous.setImage(UIImage(named : CHECKBOX_UNSELECTED) , for: .normal)
        self.btnAnonymous.setImage(UIImage(named : CHECKBOX_SELECTED) , for: .selected)
        self.btnAnonymous.isSelected = false
        
        self.imgBg.image = UIImage(named : CREATE_POST_BG)
        
        var strTitle = "Create Post"
        
        if isPostReply {
            strTitle = "Reply"
            self.lblReply.text = "Reply to : \(UserManager.sharedUserManager.name!)"
        }
        
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: strTitle , strBackButtonImage: BACK_BUTTON, selector: #selector(self.goTOBack), color: color(red: 147, green: 108, blue: 234))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 36, green: 149, blue: 178)
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
        
        if isPostReply {
            self.doCallServiceForPostReply()
        }
        else
        {
            self.doCallServiceForCreatePost()
        }
    }
    
    
    func doCallServiceForPostReply() {
        
        let params = ["userId" : UserManager.sharedUserManager.userId!,"postReply" : self.txtViewComment.text, "postId" : self.strPostID, "version" : "1.0", "os" : "2", "language" : "english"] as [String : Any]
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "createPostReply", parameter: params, success: { (responseObject) in
            print(responseObject)
            if responseObject["status"] as! String == "1"
            {
                self.txtViewComment.text = ""
                CommonUtil.showTotstOnWindow(strMessgae: "txt_success_post".localized())
            }else
            {
                
            }
        }) { (error) in
            print(error as! NSError)
        }
    }
    
    func doCallServiceForCreatePost() {
        
        var strPostAnonymous = "0"
        if self.btnAnonymous.isSelected {
            strPostAnonymous = "1"
        }
        let params = ["userId" : UserManager.sharedUserManager.userId!,"postMessage" : self.txtViewComment.text, "postAsAnonomous" : strPostAnonymous, "version" : "1.0", "os" : "2", "language" : "English"] as [String : Any]
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "CreatePost", parameter: params, success: { (responseObject) in
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
            print(error!)
        }
    }
    
    @IBAction func doClickAnonymous(sender : UIButton)
    {
        self.btnAnonymous.isSelected = !self.btnAnonymous.isSelected
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //        if ((textView.text.characters.count + 1) < 16) {
        //          //  self.lblCharacter.text = String(16 - textView.text.characters.count)
        //
        //            return true
        //        }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        if numberOfChars < 161
        {
            self.lblCharacter.text = String(160 - numberOfChars)
            return true
        }
        return false
        
        //   return false
    }
    
}
