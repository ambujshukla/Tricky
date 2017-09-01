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

class ChatDetailViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate
{
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var imgBG : UIImageView!
    @IBOutlet weak var btnYes : UIButton!
    @IBOutlet weak var btnNo : UIButton!
    @IBOutlet weak var btnSend : UIButton!
    @IBOutlet weak var viewBottom : UIView!
    @IBOutlet weak var txtChat : UITextView!
    
    //    @IBOutlet weak var htTxtViewConstraint : NSLayoutConstraint!
    //    @IBOutlet weak var bottomViewOriginConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var originConstraintTxtView: NSLayoutConstraint!
    @IBOutlet weak var heightConstrntTxtView: NSLayoutConstraint!
    
    var arrChat : NSArray = [
        ["chatMessage": "Are you Julia", "dateTime": "13:24"]
        ,["chatMessage": "No, I am not Julia", "dateTime": "13:26"]
    ]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.configureInitialParameters()
        self.decorateUI()
    }
    
    func decorateUI()
    {
        self.navigationController?.navigationBar.barTintColor = color(red: 113, green: 136, blue: 154)

        CommanUtility.decorateNavigationbarWithBackButtonAndTitle(target: self, leftselect: #selector(doClickBack), strTitle: "Michael Smith".localized(), strBackImag: BACK_BUTTON, strFontName: "Arial", size: 20, color: UIColor.white)

        self.tblView.backgroundColor = UIColor.clear
        self.imgBG.image = UIImage(named : CHAT_BG)
        self.tblView.rowHeight = UITableViewAutomaticDimension
        self.tblView.estimatedRowHeight = 65
        self.tblView.separatorColor = UIColor.clear
        self.txtChat.backgroundColor = UIColor.lightGray
        
        self.btnSend .setImage(UIImage(named : SEND_ICON), for: .normal)
        
        CommanUtility.createCustomRightButton(self, navBarItem: self.navigationItem, strRightImage: REFRESH_ICON as NSString, select: #selector(doClickRefresh))
        
        self.btnYes.backgroundColor = color(red: 113, green: 136, blue: 154)
        self.btnNo.backgroundColor = UIColor.white
        
        self.btnNo.setTitleColor(color(red: 113, green: 136, blue: 154), for: .normal)
        self.btnNo.setTitleColor(UIColor.white, for: .selected)
        
        self.btnYes.setTitleColor(color(red: 113, green: 136, blue: 154), for: .normal)
        self.btnYes.setTitleColor(UIColor.white, for: .selected)
        
        self.btnYes .isSelected = true
        
        self.btnYes.setTitle("txt_yes".localized().uppercased(), for: .normal)
        self.btnNo.setTitle("txt_no".localized().uppercased(), for: .normal)
        
        self.btnNo.layer.borderColor = color(red: 113, green: 136, blue: 154).cgColor

        self.btnYes.layer.borderColor = color(red: 113, green: 136, blue: 154).cgColor
        
        self.txtChat.backgroundColor = UIColor.clear
        self.btnNo.layer.borderWidth = 1.0
        self.btnYes.layer.borderWidth = 1.0
    }
    
    func doClickBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureInitialParameters()
    {
        IQKeyboardManager.shared().isEnabled = false
       // self.heightConstrntTxtView.constant = 50;
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
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
       //     cell.lblDate.text = dictChatData["dateTime"]
            cell.imgBG.layer.cornerRadius = 10
            cellToShow = cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellChat2") as! ChatTableViewCell
            cell.lblMessage.text = dictChatData["chatMessage"]
        //     cell.lblDate.text = dictChatData["dateTime"]
            cell.imgBG.layer.cornerRadius = 10
            cellToShow = cell
        }
       // cellToShow.layer.cornerRadius = 4.0
        cellToShow.backgroundColor = UIColor.clear
        cellToShow.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        cellToShow.selectionStyle = .none
        return cellToShow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserPostAnswerViewController") as! UserPostAnswerViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.originConstraintTxtView.constant = 0
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
        self.heightConstrntTxtView.constant = 50;
        self.txtChat.text = ""
    }
    
    @IBAction func doClickYesOrNo (id : UIButton)
    {
        self.btnNo.backgroundColor = UIColor.white
        self.btnYes.backgroundColor = UIColor.white
        self.btnYes .isSelected = false
        self.btnNo .isSelected = false

        if  id.tag == 101
        {
            self.btnYes.backgroundColor = color(red: 113, green: 136, blue: 154)
            self.btnYes .isSelected = true
        }else{
            self.btnNo.backgroundColor = color(red: 113, green: 136, blue: 154)
            self.btnNo .isSelected = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
