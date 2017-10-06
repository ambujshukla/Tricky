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

class HomeMessageController: UIViewController , UITableViewDelegate , UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
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
        self.doGetMessageList(isComeFromPullToRefresh:  false)
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.doGetMessageList(isComeFromPullToRefresh: true)
        refreshControl.endRefreshing()
    }
    
    func doGetMessageList(isComeFromPullToRefresh : Bool)
    {
        self.view.endEditing(true)
        //UpdateProfile
        let dictData = ["version" : "1.0" , "os" : "2" , "language" : "english","userId": UserManager.sharedUserManager.userId! ,"filterVulgar" : CommonUtil.filterVulgerMsg(),"messageForOnlyRegisterUser":CommonUtil.isBlockUser(),"offset":"0","limit" : "10","showOnlyFavorite":"0"] as [String : Any]
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOSTAndPullToRefresh(isShowLoder :!isComeFromPullToRefresh ,strURL: kBaseUrl, strServiceName: "getRecSentList", parameter: dictData , success: { (obj) in
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

            }
        }) { (error) in
            CommonUtil.showTotstOnWindow(strMessgae: (error?.localizedDescription)!)
        }
    }
    
    
    func doActionOnBlockButton(sender : UIButton){
        
        var strMessage = "Are you sure you want to block?"
        
        if sender.isSelected {
            strMessage = "Are you sure you want to un block?"
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
        
        let dictParam = ["userId" : UserManager.sharedUserManager.userId! , "messageId" : messageID] as [String : Any]
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
        
        let dictParam = ["userId" : UserManager.sharedUserManager.userId! , "messageId" : messageID , "type" : "\(type)"] as [String : Any]
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
        
        CommonUtil.showAlertInSwift_3Format("Are you sure you want to delete this message?", title: "txt_trickychat".localized(), btnCancel: "txt_no".localized(), btnOk: "txt_yes".localized(), crl: self, successBlock: { (obj) in
            
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
    }
    
    func doActionOnFavouriteButton(sender : UIButton) {
        
        var dictData = self.arrMessageList[sender.tag]
        let messageID = dictData["messageId"]! as! String
        let type = dictData["type"]! as! NSNumber
        
        let dictParam = ["userId" : UserManager.sharedUserManager.userId! , "messageId" : messageID , "type" : "\(type)"] as [String : Any]
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
        //        }
        //        else
        //        {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! MessageTableViewCell
        //            cell.selectionStyle = .none
        //            return cell
        //        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func doClickPlus()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func doActionOnReply(sender : UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewIdentifier") as! ChatDetailViewController
        vc.dictChatData = self.arrMessageList[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    
        
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewPostViewController") as! CreateNewPostViewController
//        controller.isPostReply = true
//        let postID : String = self.arrMessageList[sender.tag]["messageId"] as! String
//        controller.strPostID = postID
//        self.navigationController?.pushViewController(controller, animated: true)
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
                self.doGetMessageList(isComeFromPullToRefresh: true)
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
        
        let image = CommanUtility.textToImage(drawText: shareText as! NSString, inImage: #imageLiteral(resourceName: "sharemessage"), atPoint: CGPoint(x : 90 , y : 250))

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
