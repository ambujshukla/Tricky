//
//  ChatDetailViewController.swift
//  Tricky
//
//  Created by gopal sara on 23/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import IQKeyboardManager
import UITextView_Placeholder;
import DZNEmptyDataSet

class ChatDetailViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var imgBG : UIImageView!
    @IBOutlet weak var btnYes : UIButton!
    @IBOutlet weak var btnNo : UIButton!
    @IBOutlet weak var btnSend : UIButton!
    @IBOutlet weak var viewBottom : UIView!
    @IBOutlet weak var txtChat : UITextView!
    
    @IBOutlet weak var originConstraintTxtView: NSLayoutConstraint!
    @IBOutlet weak var heightConstrntTxtView: NSLayoutConstraint!
    
    var dictChatData = [String : AnyObject]()
    
    var totalCount : Int = 0
    var limit : Int = 10
    var offSet : Int = 0
    
    var arrChat = Array<Dictionary<String,AnyObject>>()
    
    //    var arrChat : NSArray = [
    //        ["chatMessage": "Are you Julia Are you Julia Are you Julia Are you Julia", "dateTime": "13:24"]
    //        ,["chatMessage": "Are you Julia Are you Julia Are you Julia Are you Julia", "dateTime": "13:24"],["chatMessage": "No, I am not Julia", "dateTime": "13:26"],["chatMessage": "No, I am not Julia", "dateTime": "13:26"],["chatMessage": "Are you Julia Are you Julia Are you Julia Are you Julia", "dateTime": "13:24"],["chatMessage": "Are you Julia Are you Julia Are you Julia Are you Julia", "dateTime": "13:24"],["chatMessage": "Are you Julia Are you Julia Are you Julia Are you Julia Are you Julia Are you Julia Are you Julia Are you Julia", "dateTime": "13:24"],["chatMessage": "Are you Julia Are you Julia Are you Julia Are you Julia", "dateTime": "13:24"]
    //    ]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.configureInitialParameters()
        self.decorateUI()
        self.doCallGetChatMessageWS(shouldShowLoader: false)
    }
    
    func decorateUI()
    {
        self.navigationController?.navigationBar.barTintColor = color(red: 113, green: 136, blue: 154)
        
        CommanUtility.decorateNavigationbarWithBackButtonAndTitle(target: self, leftselect: #selector(doClickBack), strTitle: "Michael Smith".localized(), strBackImag: BACK_BUTTON, strFontName: "Arial", size: 20, color: UIColor.white)
        
        self.tblView.backgroundColor = UIColor.clear
        self.imgBG.image = UIImage(named : CHAT_BG)
        self.tblView.rowHeight = UITableViewAutomaticDimension
        self.tblView.estimatedRowHeight = 40
        self.tblView.separatorColor = UIColor.clear
        self.txtChat.backgroundColor = UIColor.lightGray
        
        self.btnSend .setImage(UIImage(named : SEND_ICON), for: .normal)
        
        CommanUtility.createCustomRightButton(self, navBarItem: self.navigationItem, strRightImage: REFRESH_ICON as NSString, select: #selector(doClickRefresh))
        
        self.btnYes.backgroundColor = UIColor.clear
        self.btnNo.backgroundColor =  UIColor.clear
        
        self.btnYes.layer.borderWidth = 1.0
        self.btnNo.layer.borderWidth = 1.0
        
        self.btnYes.layer.borderColor = UIColor.white.cgColor
        self.btnNo.layer.borderColor = UIColor.white.cgColor
        
        self.btnNo.layer.cornerRadius = 10;
        self.btnYes.layer.cornerRadius = 10;
        
        self.btnYes.setTitle("txt_you_got_me".localized(), for: .normal)
        self.btnNo.setTitle("txt_not_got_me".localized(), for: .normal)
        
        self.txtChat.backgroundColor = UIColor.clear
        
        self.viewBottom.layer.cornerRadius = 25
    }
    
    func doCallGetChatMessageWS(shouldShowLoader : Bool)
    {
        let params = ["version" : "1.0" , "os" : "ios" , "language" : "english","userId":UserManager.sharedUserManager.userId!, "messageId" : self.dictChatData["chatId"] as! String,"receiverId" :self.dictChatData["userId"] as! String, "lastMessageDateTime": "2017-09-01 12:23:23", "chatId" : self.dictChatData["chatId"] as! String]  as [String : Any]
        print(params)
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOSTAndPullToRefresh(isShowLoder: shouldShowLoader, strURL: kBaseUrl, strServiceName: "getChatMessageList", parameter: params, success: { (obj) in
            print(obj)
        }) { (error) in
            print(error)
        }
    }
    
    func doClickBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureInitialParameters()
    {
        IQKeyboardManager.shared().isEnabled = false
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.tblView.emptyDataSetSource = self
        self.tblView.emptyDataSetDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatDetailViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatDetailViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.txtChat.delegate = self
    }
    
    func doClickRefresh()
    {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrChat.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView() // The width will be the same as the cell, and the height should be set in tableView:heightForRowAtIndexPath:
        
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellToShow : UITableViewCell!
        let dictChatData : [String : String] = self.arrChat[indexPath.row] as! [String : String]
        if (indexPath.row%2) == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellChat1") as! ChatTableViewCell
            cell.lblMessage.text = dictChatData["chatMessage"]
            cell.imgBG.layer.cornerRadius = 10
            cell.imgBG.backgroundColor = UIColor.white
            cellToShow = cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellChat2") as! ChatTableViewCell
            cell.lblMessage.text = dictChatData["chatMessage"]
            cell.imgBG.layer.cornerRadius = 10
            cell.imgBG.backgroundColor = UIColor.white
            cellToShow = cell
        }
        // cellToShow.layer.cornerRadius = 4.0
        cellToShow.backgroundColor = UIColor.clear
        cellToShow.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        cellToShow.selectionStyle = .none
        return cellToShow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.originConstraintTxtView.constant = 10
                UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        }
    }
    func keyboardWillShow(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardHeight = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.originConstraintTxtView.constant = keyboardHeight
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        self.originConstraintTxtView.constant = 220;
        return true
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool
    {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height < 40 {
            return true
        }
        if !(newSize.height > 110)
        {
            self.heightConstrntTxtView.constant = newSize.height;
        }
        return true
    }
    
    @IBAction func doClickSend(id : UIButton)
    {
        self.heightConstrntTxtView.constant = 33;
        self.txtChat.text = ""
    }
    
    @IBAction func doClickYesOrNo (id : UIButton)
    {
        
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?
    {
        return  NSAttributedString(string:"txt_no_record".localized(), attributes:
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: Font_Helvetica_Neue, size: 14.0)!])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
