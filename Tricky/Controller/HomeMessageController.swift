//
//  MessageViewController.swift
//  Tricky
//
//  Created by gopal sara on 19/08/17.
//  Copyright © 2017 gopal sara. All rights reserved.
//

import UIKit
import AAPopUp
import DZNEmptyDataSet

class HomeMessageController: GAITrackedViewController , UITableViewDelegate , UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    @IBOutlet weak var tblMessage : UITableView!
    @IBOutlet weak var btnPlus : UIButton!
    
    var arrMessageList = [[String : AnyObject]]()
    {
        didSet{
            self.tblMessage.reloadData()
        }
    }
    var totalCount : Int = 0
    var limit : Int = 10
    var offSet : Int = 0
    
    @IBOutlet weak var activityView : UIActivityIndicatorView!
    @IBOutlet weak var vwFotter : UIView!
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
        self.doGetMessageList(isComeFromPullToRefresh:  false , isShowLoader:  true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Set screen name.
        self.screenName = "Message Home";
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.offSet = 0
        self.doGetMessageList(isComeFromPullToRefresh: true , isShowLoader:  false)
        refreshControl.endRefreshing()
    }
    
    func doGetMessageList(isComeFromPullToRefresh : Bool , isShowLoader : Bool)
    {
        self.view.endEditing(true)
        //UpdateProfile
        let dictData = ["version" : "1.0" , "os" : "2" , "language" : "english","userId": CommonUtil.getUserId() ,"filterVulgar" : CommonUtil.filterVulgerMsg(),"messageForOnlyRegisterUser":CommonUtil.isBlockUser(),"offset":"\(self.offSet)","limit" : "\(self.limit)","showOnlyFavorite":"0"] as [String : Any]
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOSTAndPullToRefresh(isShowLoder :isShowLoader ,strURL: kBaseUrl, strServiceName: "getRecSentList", parameter: dictData , success: { (obj) in
            print("this is object \(obj)")
            if (obj["status"] as! String == "1")
            {
                let strSentMsgC = String(describing: obj["sentMessageCount"]!)
                let strReceiveMsgC = String(describing: obj["RecieveMessageCount"]!)
                
                UserManager.sharedUserManager.doSetReceiveMsgAndSentMessage(strSentMsg: strSentMsgC, strReceiveMsg: strReceiveMsgC)
                
                if let result : Array<Dictionary<String, Any>> = obj["responseData"] as? Array<Dictionary<String, Any>>
                {
                    self.totalCount = obj["totalRecordCount"] as! Int
                    
                    
                    if isComeFromPullToRefresh {
                        self.arrMessageList.removeAll()
                    }
                    for(_, element) in result.enumerated()
                    {
                        self.arrMessageList .append(element as [String : AnyObject])
                    }
                }
                else {
                    self.hideAndShowFotterView(isHideFotter: true, isAnimateActivityInd: false)
                }
                
            }else{
                self.activityView.stopAnimating()
                self.vwFotter.isHidden = true
                UserManager.sharedUserManager.doSetReceiveMsgAndSentMessage(strSentMsg: "0", strReceiveMsg: "0")
            }
        }) { (error) in
            self.activityView.stopAnimating()
            self.vwFotter.isHidden = true
            UserManager.sharedUserManager.doSetReceiveMsgAndSentMessage(strSentMsg: "0", strReceiveMsg: "0")
            CommonUtil.showTotstOnWindow(strMessgae: "txt_something_went_wrong".localized())
        }
    }
    
    
    func doActionOnBlockButton(sender : UIButton){
        
        var strMessage =  "txt_block".localized()
        
        if sender.isSelected {
            strMessage = "txt_unblock".localized()
        }
        
        CommonUtil.showAlertInSwift_3Format(strMessage, title: "txt_trickychat".localized(), btnCancel: "txt_no".localized(), btnOk: "txt_yes".localized(), crl: self, successBlock: { (obj) in
            
            self.doCallServiceForBlockMessage(sender: sender)
            
        }) { (obj) in
            print("ok")
        }
    }
    
    func doCallServiceForBlockMessage(sender : UIButton){
        
        var dictData = self.arrMessageList[sender.tag]
        let messageID = dictData["messageId"]! as! String
        
        let dictParam = ["userId" : CommonUtil.getUserId() , "messageId" : messageID] as [String : Any]
        print(dictParam)
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl , strServiceName: "blockMessageUser", parameter: dictParam , success: { (responseObject) in
            print("this is object \(responseObject)")
            if(responseObject["status"] as! String == "1"){
                
                if let resultData : Array<Dictionary<String, Any>> = responseObject["responseData"] as? Array<Dictionary<String, Any>> {
                    
                    dictData["isUserBlock"] = resultData[0]["isBlocked"]  as AnyObject
                    self.arrMessageList[sender.tag] = dictData
                    self.tblMessage.reloadData()
                }
                self.arrMessageList[sender.tag] = dictData
            }
            else
            {
                CommonUtil.showTotstOnWindow(strMessgae: responseObject["responseMessage"] as! String)
            }
        }) { (error) in
            
        }
    }
    
    func doCallServiceForRemoveMessage(sender : UIButton){
        
        var dictData = self.arrMessageList[sender.tag]
        let messageID = dictData["messageId"]! as! String
        let type = dictData["type"]! as! NSNumber
        
        let dictParam = ["userId" : CommonUtil.getUserId() , "messageId" : messageID , "type" : "\(type)"] as [String : Any]
        print(dictParam)
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl , strServiceName: "removeMessage", parameter: dictParam , success: { (responseObject) in
            print("this is object \(responseObject)")
            if(responseObject["status"] as! String == "1"){
                
                self.arrMessageList.remove(at: sender.tag)
            }
            else
            {
                CommonUtil.showTotstOnWindow(strMessgae: responseObject["responseMessage"] as! String)
            }
            
        }) { (error) in
        }
    }
    
    func doActionOnDeleteMessage(sender : UIButton){
        
        CommonUtil.showAlertInSwift_3Format("txt_msg_dlt".localized(), title: "txt_trickychat".localized(), btnCancel: "txt_no".localized(), btnOk: "txt_yes".localized(), crl: self, successBlock: { (obj) in
            
            self.doCallServiceForRemoveMessage(sender: sender)
            
        }) { (obj) in
            print("ok")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func decorateUI () {
        
        self.tblMessage.addSubview(self.refreshControl)
        self.tblMessage.rowHeight = UITableViewAutomaticDimension;
        self.tblMessage.estimatedRowHeight = 90.0;
        self.activityView.startAnimating()
        
        self.tblMessage.emptyDataSetSource = self
        self.tblMessage.emptyDataSetDelegate = self
        self.hideAndShowFotterView(isHideFotter: true, isAnimateActivityInd: false)
        
    }
    
    func doActionOnFavouriteButton(sender : UIButton) {
        
        var dictData = self.arrMessageList[sender.tag]
        let messageID = dictData["messageId"]! as! String
        let type = dictData["type"]! as! NSNumber
        
        let dictParam = ["userId" : CommonUtil.getUserId() , "messageId" : messageID , "type" : "\(type)"] as [String : Any]
        print(dictParam)
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl , strServiceName: "favoriteMsg", parameter: dictParam , success: { (responseObject) in
            print("this is object \(responseObject)")
            if(responseObject["status"] as! String == "1"){
                
                if let resultData : Array<Dictionary<String, Any>> = responseObject["responseData"] as? Array<Dictionary<String, Any>> {
                    
                    
                    dictData["isFavorite"] = resultData[0]["isFavorite"]  as AnyObject
                    self.arrMessageList[sender.tag] = dictData
                    self.tblMessage.reloadData()
                }
                self.arrMessageList[sender.tag] = dictData
            }
            else
            {
                CommonUtil.showTotstOnWindow(strMessgae: responseObject["responseMessage"] as! String)
            }
            
        }) { (error) in
        }
    }
    
    //MARK: - Tableview delegate and datasource methods
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrMessageList.count
    }
    
    // MARK: - Table View Delegates
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellToReturn : UITableViewCell!
        let dictData = self.arrMessageList[indexPath.row]
        if let senderId = dictData["senderId"] as? String {
            
            if senderId == CommonUtil.getUserId()  {
                cellToReturn = self.doConfigReciverCell(dictData: dictData, indexPath: indexPath, tableView: tableView)
            }else{
                cellToReturn = self.doConfigSenderCell(dictData: dictData, indexPath: indexPath, tableView: tableView)
            }
        }
        else{
            cellToReturn = self.doConfigReciverCell(dictData: dictData, indexPath: indexPath, tableView: tableView)
        }
        return cellToReturn
    }
    
    
    func doConfigSenderCell(dictData : [String : AnyObject] , indexPath : IndexPath , tableView : UITableView)-> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! MessageTableViewCell
        cell.decorateTableViewCell(dictData: self.arrMessageList[indexPath.row])
        
        cell.btnfavourite.tag = indexPath.row
        cell.btnShare.tag = indexPath.row
        cell.btnReply.tag = indexPath.row
        cell.btnBlock.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        
        cell.btnfavourite.addTarget(self, action: #selector(self.doActionOnFavouriteButton(sender:)), for: .touchUpInside)
        cell.btnBlock.addTarget(self, action: #selector(self.doActionOnBlockButton(sender:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(self.doActionOnDeleteMessage(sender:)), for: .touchUpInside)
        cell.btnReply.addTarget(self, action: #selector(self.doActionOnReply(sender:)), for: .touchUpInside)
        cell.btnShare.addTarget(self, action: #selector(self.doActionOnShare(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func doConfigReciverCell(dictData : [String : AnyObject] , indexPath : IndexPath , tableView : UITableView) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! MessageTableViewCell
        cell.lblTo.text = "To: \(dictData["recieverName"] as! String)"
        
        let isFavourite = dictData["isFavorite"] as! Bool
        if isFavourite {
            cell.btnfavourite.isSelected = true
        }
        else
        {
            cell.btnfavourite.isSelected = false
        }
        cell.lblMessage.text = dictData["message"] as? String
        
        let date : Date = CommanUtility.convertAStringIntodDte(time : (dictData["time"] as? String)! , formate : "yyyy-MM-dd HH:mm:ss")
        cell.lblTime.text = CommonUtil.timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        
        cell.btnfavourite.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnfavourite.addTarget(self, action: #selector(self.doActionOnFavouriteButton(sender:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(self.doActionOnDeleteMessage(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictData = self.arrMessageList[indexPath.row]
        if dictData["senderId"] as! String == CommonUtil.getUserId()  {
            return
        }
        let isBlock = dictData["isUserBlock"] as! Bool
        if isBlock
        {
            CommonUtil.showTotstOnWindow(strMessgae: "txt_message_user_blocked".localized())
        }else
        {
            //you have blocked this user
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewIdentifier") as! ChatDetailViewController
            
            var dictLocalData = self.arrMessageList[indexPath.row]
            dictLocalData["receiverId"] = dictLocalData["senderId"]
            vc.dictChatData = dictLocalData
            vc.strChatId = vc.dictChatData["messageId"] as! String
            vc.strChatMessage = vc.dictChatData["message"] as! String
            vc.strName = vc.dictChatData["senderName"] as! String
            vc.strMessageId = vc.dictChatData["messageId"] as! String
            vc.strReceiverId = vc.dictChatData["recieverId"] as! String
            vc.strSenderId =  dictData["senderId"] as! String
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func doClickPlus()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        vc.contactShowFrom = 3
        vc.isFromMenu = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func doActionOnReply(sender : UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewIdentifier") as! ChatDetailViewController
        var dictLocalData = self.arrMessageList[sender.tag]
        dictLocalData["receiverId"] = dictLocalData["senderId"]
        vc.dictChatData = dictLocalData
        vc.strChatId = vc.dictChatData["messageId"] as! String
        vc.strChatMessage = vc.dictChatData["message"] as! String
        vc.strName = vc.dictChatData["senderName"] as! String
        vc.strMessageId = vc.dictChatData["messageId"] as! String
        vc.strReceiverId = vc.dictChatData["recieverId"] as! String
        vc.strSenderId =  vc.dictChatData["senderId"] as! String
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func hideAndShowFotterView(isHideFotter : Bool , isAnimateActivityInd : Bool){
        
        self.vwFotter.isHidden = isHideFotter
        (isAnimateActivityInd) ? self.activityView.startAnimating() : self.activityView.stopAnimating()
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastElement = self.arrMessageList.count - 1
        if indexPath.row == lastElement{
            
            if self.totalCount != self.arrMessageList.count {
                self.offSet += 10
                self.doGetMessageList(isComeFromPullToRefresh: false , isShowLoader:  false)
                self.hideAndShowFotterView(isHideFotter: false, isAnimateActivityInd: true)
            }
            else{
                self.hideAndShowFotterView(isHideFotter: true, isAnimateActivityInd: false)
            }
        }
    }
    
    func doActionOnShare(sender : UIButton)
    {
        let dictData = self.arrMessageList[sender.tag]
        let shareText = dictData["message"]
        
        var yOrigin : Int = 600
        
        if (shareText?.length)! <= 20 {
            yOrigin = 550
        }
        
       else if (shareText?.length)! <= 60 {
            yOrigin = 520
        }
       else if (shareText?.length)! <= 100 {
            yOrigin = 480
        }
        else if(shareText?.length)! <= 200 {
            yOrigin = 450
        }
        
        let image = CommanUtility.textToImage(drawText: shareText as! NSString, inImage: #imageLiteral(resourceName: "sharemessage"), atPoint: CGPoint(x : 120 , y : yOrigin))
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?
    {
        return  NSAttributedString(string:"txt_no_record".localized(), attributes:
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: Font_Helvetica_Neue, size: 14.0)!])
    }
}

extension Date {
    
    func offsetFrom(date: Date) -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self);
        
        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + " " + seconds
        let hours = "\(difference.hour ?? 0)h" + " " + minutes
        let days = "\(difference.day ?? 0)d" + " " + hours
        
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
    
}
