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
import RealmSwift

class ChatDetailViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var imgBG : UIImageView!
//    @IBOutlet weak var btnYes : UIButton!
//    @IBOutlet weak var btnNo : UIButton!
    @IBOutlet weak var btnSend : UIButton!
    @IBOutlet weak var viewBottom : UIView!
    @IBOutlet weak var txtChat : UITextView!
    @IBOutlet weak var originConstraintTxtView: NSLayoutConstraint!
    @IBOutlet weak var heightConstrntTxtView: NSLayoutConstraint!
    
    var lastTimeSyncTime : String = "0"
    var lastTimeStamp = 0
    var dictChatData = [String : AnyObject]()
    
    var totalCount : Int = 0
    var limit : Int = 2
    var offSet : Int = 0
    var strName : String = ""
    var arrChat = List<ChatData>()
    var strChatId : String = ""
    var strReceiverId : String = ""

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.doCallGetChatMessageWS(shouldShowLoader: false)
        refreshControl.endRefreshing()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.configureInitialParameters()
        self.decorateUI()
        self.doCallGetChatMessageWS(shouldShowLoader: true)
    }
    
    func decorateUI()
    {
        self.navigationController?.navigationBar.barTintColor = color(red: 113, green: 136, blue: 154)
        
        self.tblView.addSubview(self.refreshControl)
        
        CommanUtility.decorateNavigationbarWithBackButtonAndTitle(target: self, leftselect: #selector(doClickBack), strTitle: self.strName , strBackImag: BACK_BUTTON, strFontName: "Arial", size: 20, color: UIColor.white)
        
        self.tblView.backgroundColor = UIColor.clear
        self.imgBG.image = UIImage(named : CHAT_BG)
        self.tblView.rowHeight = UITableViewAutomaticDimension
        self.tblView.estimatedRowHeight = 40
        self.tblView.separatorColor = UIColor.clear
        self.txtChat.backgroundColor = UIColor.lightGray
        self.btnSend .setImage(UIImage(named : SEND_ICON), for: .normal)
        self.txtChat.backgroundColor = UIColor.clear
        self.viewBottom.layer.cornerRadius = 15
    }
    
    func doCallGetChatMessageWS(shouldShowLoader : Bool)
    {
        let params = ["version" : "1.0" , "os" : "2" , "language" : "english","userId":CommonUtil.getUserId(), "messageId" : self.strChatId ,"receiverId" :self.strReceiverId, "lastMessageDateTime" : self.lastTimeSyncTime, "chatId" : self.strChatId,"limit" : "\(self.limit)","offset" : "\(self.offSet)"]  as [String : Any]
        
        print(params)
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOSTAndPullToRefresh(isShowLoder: shouldShowLoader, strURL: kBaseUrl, strServiceName: "getChatMessageList", parameter: params, success: { (obj) in
            print(obj)
            if let chatData : Array<Dictionary<String,AnyObject>> = obj["responseData"] as? Array<Dictionary<String,AnyObject>>
            {
                self.offSet += 1
                self.doPopulateDataIn(arrChat : chatData)
            }
            self.doGetChatData()
        }) { (error) in
              self.doGetChatData()
            print(error!)
        }
    }
    
    func doClickBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureInitialParameters()
    {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        IQKeyboardManager.shared().isEnabled = false
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.tblView.emptyDataSetSource = self
        self.tblView.emptyDataSetDelegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatDetailViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatDetailViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.txtChat.delegate = self
    }
    
    @IBAction func doClickRefresh()
    {
        self.lastTimeSyncTime = "0"
        self.arrChat.removeAll()
        self.doCallGetChatMessageWS(shouldShowLoader: true)
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
        let view = UIView()
        
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellToShow : UITableViewCell!
        let chatData : ChatData = self.arrChat[indexPath.row] as! ChatData
        if chatData.senderId == CommonUtil.getUserId() {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellChat2") as! ChatTableViewCell
            cell.lblMessage.text = chatData.message
            cell.imgBG.layer.cornerRadius = 10
            cell.imgBG.backgroundColor = UIColor.white
            cellToShow = cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellChat1") as! ChatTableViewCell
            cell.lblMessage.text = chatData.message
            cell.imgBG.layer.cornerRadius = 10
            cell.imgBG.backgroundColor = UIColor.white
            cellToShow = cell
        }
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
        
         let params = ["version" : "1.0" , "os" : "2" , "language" : "english","userId":CommonUtil.getUserId(), "messageId" : self.strChatId,"receiverId" :self.strReceiverId, "message": self.txtChat.text, "type" : "0","lastMessageDateTime" : self.doGetCurrentTime(),"status" : "0"]  as [String : Any]
         print(params)
         WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOSTAndPullToRefresh(isShowLoder: false, strURL: kBaseUrl, strServiceName: "sendChatMessage", parameter: params, success: { (obj) in
         if(obj["status"] as! String == "1")
         {
         print(obj)
         if let chatData : Array<Dictionary<String,AnyObject>> = obj["responseData"] as? Array<Dictionary<String,AnyObject>>
         {
         self.doPopulateDataIn(arrChat : chatData)
         self.doGetChatData()
         }
         }
         }) { (error) in
         print(error!)
         }
         
         self.heightConstrntTxtView.constant = 33;
         self.txtChat.text = ""
 
    }
    
    func doGetCurrentTime() -> String
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let result = formatter.string(from: date)
        return result
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
    
    func doGetChatData()
    {
        let realm = try! Realm()
        
        let predicate = NSPredicate(format: "(((senderId = %@ AND receiverId = %@) || (receiverId = %@ AND senderId = %@)) && timeStamp > %d)", self.dictChatData["senderId"] as! String, self.strReceiverId,self.dictChatData["senderId"] as! String, self.strReceiverId,self.lastTimeStamp)
        
        let objs = realm.objects(ChatData.self).filter(predicate)
        
        //        if objs.count > 9
        //        {
        //            for i in 0..<10
        //            {
        //                self.arrChat .append(objs[i])
        //            }
        //        }else{
        //            self.arrChat .append(objectsIn: objs)
        //        }
        
        self.arrChat .append(objectsIn: objs)
        
        if self.arrChat.count > 0
        {
            let chatTempData = self.arrChat.last
            self.lastTimeSyncTime = (chatTempData?.time)!
            self.lastTimeStamp = (chatTempData?.timeStamp)!
            self.tblView.reloadData()
            //   perform(#selector(scrollToBottom), with: nil, afterDelay: 1.0)
            //perform(#selector(scrollToBottom()), with: nil, afterDelay: 1.0, inModes: [.commonModes])
        }
    }
    
    func doPopulateDataIn(arrChat : Array<Dictionary<String,AnyObject>>)
    {
        for dictData in arrChat
        {
            let realm = try! Realm()
            
            let predicate = NSPredicate(format: "messageId = %@", dictData["messageId"] as! String)
            let arrTempChat = realm.objects(ChatData.self).filter(predicate)
            if arrTempChat.count == 0
            {
                let chatObj = ChatData()
                chatObj.message = dictData["message"] as!  String
                chatObj.time = dictData["time"] as!  String
                chatObj.senderId = dictData["senderId"] as!  String
                if let val = dictData["isFavorite"] {
                    chatObj.isFavorite = val as! Int
                }else{
                    chatObj.isFavorite = 0
                }
                chatObj.type = dictData["type"] as!  String
                chatObj.messageId = dictData["messageId"] as!  String
                chatObj.timeStamp = self .doGetTimeStamp(date: dictData["time"] as!  String)
                if chatObj.senderId == self.strReceiverId
                {
                    chatObj.receiverId = self.dictChatData["senderId"] as! String
                }else
                {
                    chatObj.receiverId = self.strReceiverId
                }
                try! realm.write
                {
                    realm.add(chatObj)
                }
            }
        }
    }
    
    @objc func scrollToBottom(){
        DispatchQueue.global(qos: .background).async {
            let indexPath = IndexPath(row: self.arrChat.count-1, section: 0)
            self.tblView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    func doGetTimeStamp(date : String) -> Int
    {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let date = dfmatter.date(from: date)
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let dateSt:Int = Int(dateStamp)
        return dateSt
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
