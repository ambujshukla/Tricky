//
//  ChatViewController.swift
//  Tricky
//
//  Created by gopal sara on 19/08/17.
//  Copyright © 2017 gopal sara. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ChatViewController: GAITrackedViewController  , UITableViewDataSource , UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{
    
    @IBOutlet weak var tblChat : UITableView!
    
    var chatData =  [[String : AnyObject]](){
        didSet {
            self.tblChat.reloadData()
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

    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.doCallWebServiceForGetChatList(isComeFromPullToRefresh: true , isShowLoader:  false)
        refreshControl.endRefreshing()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Set screen name.
        self.screenName = "Chat Home"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func decorateUI() {
        self.tblChat.addSubview(self.refreshControl)
        self.doCallWebServiceForGetChatList(isComeFromPullToRefresh:  false , isShowLoader:  true)
        self.tblChat.emptyDataSetSource = self
        self.tblChat.emptyDataSetDelegate = self
        self.hideAndShowFotterView(isHideFotter: true, isAnimateActivityInd: false)
    }
    
    func doCallWebServiceForGetChatList(isComeFromPullToRefresh : Bool , isShowLoader : Bool)
    {
        
        
        
        let dictData = ["userId" : CommonUtil.getUserId() , "os" : "2" , "version" : "1.0" , "language" : CommanUtility.getCurrentLanguage() , "limit" : "10" , "offset" : "0"] as [String : Any]
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOSTAndPullToRefresh(isShowLoder :isShowLoader , strURL: kBaseUrl , strServiceName: "chatList", parameter: dictData, success: { (obj) in
            print(obj)
            if (obj["status"] as! String == "1"){
                

                if let result : Array<Dictionary<String, Any>> = obj["responseData"] as? Array<Dictionary<String, Any>>
                {
                self.totalCount = obj["totalRecordCount"] as! Int
                if isComeFromPullToRefresh {
                  self.chatData.removeAll()
                }
                    for(_, element) in result.enumerated()
                    {
                        self.chatData .append(element as [String : AnyObject])
                    }
                    
                }
            }
            else{
                CommonUtil.showTotstOnWindow(strMessgae: obj["responseMessage"] as! String)
                self.hideAndShowFotterView(isHideFotter: true, isAnimateActivityInd: false)

            }
        }) { (error) in
            self.hideAndShowFotterView(isHideFotter: true, isAnimateActivityInd: false)
    
        }
    }
    
    //MARK: - Tableview delegate and datasource methods
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.chatData.count
    }
    
    // MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ChatListCell
        cell.doSetDataOnCell(dictData: self.chatData[indexPath.row])
        cell.selectionStyle = .none
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.doActionDelete(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewIdentifier") as! ChatDetailViewController
        var dictData = self.chatData[indexPath.row]
        vc.dictChatData = dictData
        vc.strName = dictData["receiverName"] as! String
        vc.strChatMessage = dictData["chatMessage"] as! String
        vc.strReceiverId = dictData["receiverId"] as! String
        vc.strMessageId =  dictData["messageId"] as! String
        vc.strSenderId =  dictData["senderId"] as! String
        
        self.navigationController?.pushViewController(vc
            , animated: true)
    }
    
    func doActionDelete(sender : UIButton)
    {
        CommonUtil.showAlertInSwift_3Format("Are you sure you want to delete?", title: "Alert", btnCancel: "txt_no".localized(), btnOk: "txt_yes".localized(), crl: self, successBlock: { (no) in
            let dictData = self.chatData[sender.tag]
            
            let params = ["version" : "1.0" , "os" : "ios" , "language" : CommanUtility.getCurrentLanguage(),"userId":dictData["userId"]!,"chatId" :dictData["chatId"]!] as [String : Any]
            WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "deleteChat", parameter: params, success: { (responseObject) in
                print(responseObject)
                if (responseObject["status"] as! String  == "1")
                {
                    self.totalCount = self.totalCount - 1
                    self.chatData .remove(at: sender.tag)
                    
                }
                else {
                }
            }) { (error) in
                print("")
            }
        }) { (no) in
            
        }
    }
    
    
    func hideAndShowFotterView(isHideFotter : Bool , isAnimateActivityInd : Bool){
        
        self.vwFotter.isHidden = isHideFotter
        (isAnimateActivityInd) ? self.activityView.startAnimating() : self.activityView.stopAnimating()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastElement = self.chatData.count - 1
        if indexPath.row == lastElement{
            
            if self.totalCount != self.chatData.count {
                self.offSet += 10
                self.doCallWebServiceForGetChatList(isComeFromPullToRefresh: false , isShowLoader:  false)
                self.hideAndShowFotterView(isHideFotter: true, isAnimateActivityInd: true)
            }
           else{
               self.hideAndShowFotterView(isHideFotter: true, isAnimateActivityInd: false)
            }
        }
    }

    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?
    {
           return  NSAttributedString(string:"txt_no_record".localized(), attributes:
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: Font_Helvetica_Neue, size: 14.0)!])
    }
}
