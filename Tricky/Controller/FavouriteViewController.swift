//
//  FavouriteViewController.swift
//  Tricky
//
//  Created by gopal sara on 22/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import AAPopUp
import DZNEmptyDataSet

class FavouriteViewController: GAITrackedViewController , UITableViewDelegate , UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var tblFav : UITableView!
    var arrMessageList = [Dictionary<String, AnyObject>]()
    var offSet : Int = 0
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.offSet = 0
        self.doGetMessageList(isComeFromPullToRefresh: true)
        refreshControl.endRefreshing()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
        self.doGetMessageList(isComeFromPullToRefresh:  false)
    }
    
    func doGetMessageList(isComeFromPullToRefresh : Bool)
    {
        self.view.endEditing(true)
        
        
        let dictData = ["version" : "1.0" , "os" : "2" , "language" : CommanUtility.getCurrentLanguage(),"userId":CommonUtil.getUserId(),"filterVulgar" : CommonUtil.getDataForKey("filterMessage") ?? "0","messageForOnlyRegisterUser":CommonUtil.getDataForKey("isBlockUser") ?? "1","offset":"0","limit" : "1000","showOnlyFavorite":"1"] as [String : Any]
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "getRecSentList", parameter: dictData , success: { (obj) in
            
            if (obj["status"] as! String == "1")
            {
                if let result : Array<Dictionary<String, Any>> = obj["responseData"] as? Array<Dictionary<String, Any>>
                {
                    if isComeFromPullToRefresh {
                        self.arrMessageList.removeAll()
                    }
                    for(_, element) in result.enumerated()
                    {
                        self.arrMessageList .append(element as [String : AnyObject])
                    }
                    self.tblFav.reloadData()
                }
            }
            print("this is object \(obj)")
        }) { (error) in
            CommonUtil.showTotstOnWindow(strMessgae: "txt_something_went_wrong".localized())
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func decorateUI ()
    {
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "txt_favorite".localized(), strBackButtonImage: BACK_BUTTON, selector: #selector(self.goTOBack), color: color(red: 181, green: 121, blue: 240))
        
        self.tblFav.rowHeight = UITableViewAutomaticDimension;
        self.tblFav.estimatedRowHeight = 90.0;
        
        self.tblFav.delegate = self
        self.tblFav.dataSource = self
        
        self.tblFav.emptyDataSetSource = self
        self.tblFav.emptyDataSetDelegate = self
        
        let revealViewController: SWRevealViewController? = self.revealViewController()
        if revealViewController != nil {
            CommanUtility.decorateNavigationbarWithRevealToggleButton(target : revealViewController!, strTitle: "txt_trickychat".localized(), strBackButtonImage: "menuicon", selector: #selector(SWRevealViewController.revealToggle(_:)) , controller : self , color:  color(red: 56, green: 152, blue: 108) )
            navigationController?.navigationBar.addGestureRecognizer(revealViewController!.panGestureRecognizer())
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Set screen name.
        self.screenName = "Favourite";
        self.navigationController?.navigationBar.barTintColor = color(red: 181, green: 121, blue: 240)
    }
    
    func goTOBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Tableview delegate and datasource methods
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
            
            if senderId == ""{
                cellToReturn = self.doConfigReciverCellFromLink(dictData: dictData, indexPath: indexPath, tableView: tableView)
                
            }
                
            else if senderId == CommonUtil.getUserId()  {
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
        
        cell.btnfavourite.addTarget(self, action: #selector(self.doCallServiceForFavouriteMessage(sender:)), for: .touchUpInside)
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
        cell.btnfavourite.addTarget(self, action: #selector(self.doCallServiceForFavouriteMessage(sender:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(self.doActionOnDeleteMessage(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
        
    }
    
    
    func doConfigReciverCellFromLink(dictData : [String : AnyObject] , indexPath : IndexPath , tableView : UITableView) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! MessageTableViewCell
      //  cell.lblTo.text = "To: \(dictData["recieverName"] as! String)"
        
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
        cell.btnfavourite.addTarget(self, action: #selector(self.doCallServiceForFavouriteMessage(sender:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(self.doActionOnDeleteMessage(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dictData = self.arrMessageList[indexPath.row]
        
        if let senderId = dictData["senderId"] as? String {
            
            if senderId == ""{
                return
            }
        }
        else{
            return
        }
        
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
            vc.dictChatData = dictData
            vc.strChatMessage = vc.dictChatData["message"] as! String
            vc.strName = vc.dictChatData["senderName"] as! String
            vc.strMessageId = vc.dictChatData["messageId"] as! String
            vc.strReceiverId = vc.dictChatData["recieverId"] as! String
            vc.strSenderId =  dictData["senderId"] as! String
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func doActionOnDeleteMessage(sender : UIButton){
        
        CommonUtil.showAlertInSwift_3Format("txt_msg_dlt".localized(), title: "txt_trickychat".localized(), btnCancel: "txt_no".localized(), btnOk: "txt_yes".localized(), crl: self, successBlock: { (obj) in
            
            self.doCallServiceForRemoveMessage(sender: sender)
            
        }) { (obj) in
            print("ok")
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

    func doActionOnBlockButton(sender : UIButton){
        
        var strMessage = "txt_block".localized()
        
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
                    self.tblFav.reloadData()
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

    
    func doCallServiceForFavouriteMessage(sender : UIButton)
    {
        var dictData = self.arrMessageList[sender.tag]
        let messageID = dictData["messageId"]! as! String
        let type = dictData["type"]! as! NSNumber
        
        let dictParam = ["userId" : CommonUtil.getUserId() , "messageId" : messageID , "type" : "\(type)"] as [String : Any]
        print(dictParam)
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl , strServiceName: "favoriteMsg", parameter: dictParam , success: { (responseObject) in
            print("this is object \(responseObject)")
            if(responseObject["status"] as! String == "1")
            {
                self.arrMessageList.remove(at: sender.tag)
                self.tblFav.reloadData()
            }
            else
            {
                CommonUtil.showTotstOnWindow(strMessgae: responseObject["responseMessage"] as! String)
            }
        }) { (error) in
        }
    }
    
    func doActionOnReply(sender : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewIdentifier") as! ChatDetailViewController
        var dictLocalData = self.arrMessageList[sender.tag]
        vc.dictChatData = dictLocalData
        vc.strChatMessage = vc.dictChatData["message"] as! String
        vc.strName = vc.dictChatData["senderName"] as! String
        vc.strMessageId = vc.dictChatData["messageId"] as! String
        vc.strReceiverId = vc.dictChatData["recieverId"] as! String
        vc.strSenderId =  vc.dictChatData["senderId"] as! String
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        let vc = UIActivityViewController(activityItems: [image,"#trickychat @trickychat"], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?
    {
        return  NSAttributedString(string:"txt_no_record".localized(), attributes:
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: Font_Helvetica_Neue, size: 14.0)!])
    }
    
}
