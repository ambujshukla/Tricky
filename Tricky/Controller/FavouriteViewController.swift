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

class FavouriteViewController: UIViewController , UITableViewDelegate , UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var tblFav : UITableView!
    var arrMessageList = [Dictionary<String, AnyObject>]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
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
        let dictData = ["version" : "1.0" , "os" : "ios" , "language" : "english","userId":CommonUtil.getUserId(),"filterVulgar" : "0","messageForOnlyRegisterUser":"0","offset":"0","limit" : "10","showOnlyFavorite":"1"] as [String : Any]
        
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
            CommonUtil.showTotstOnWindow(strMessgae: (error?.localizedDescription)!)
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func decorateUI ()
    {
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "Favourite", strBackButtonImage: BACK_BUTTON, selector: #selector(self.goTOBack), color: color(red: 181, green: 121, blue: 240))
        
        self.tblFav.rowHeight = UITableViewAutomaticDimension;
        self.tblFav.estimatedRowHeight = 90.0;
        
        self.tblFav.emptyDataSetSource = self
        self.tblFav.emptyDataSetDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 181, green: 121, blue: 240)
    }
    
    func goTOBack()
    {
        self.navigationController?.popViewController(animated: true)
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! MessageTableViewCell
        cell.decorateTableViewCell(dictData: self.arrMessageList[indexPath.row])
        cell.btnBlock.addTarget(self, action: #selector(self.doActionOnBlockButton(sender:)), for: .touchUpInside)
        cell.btnfavourite.addTarget(self, action: #selector(self.doCallServiceForFavouriteMessage(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        cell.btnReply.addTarget(self, action: #selector(self.doActionOnReply(sender:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(self.doActionOnDeleteMessage(sender:)), for: .touchUpInside)
        cell.btnShare.addTarget(self, action: #selector(self.doActionOnShare(sender:)), for: .touchUpInside)
        cell.btnShare.tag = indexPath.row
        cell.btnReply.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnfavourite.tag = indexPath.row
        cell.btnBlock.tag = indexPath.row
        let dictData = self.arrMessageList[indexPath.row];
        if ((dictData["isUserBlock"] as! Int) == 1)
        {
            cell.btnBlock.setImage(UIImage(named : "blockselecticon"), for: .normal)
        }else{
            cell.btnBlock.setImage(UIImage(named : "unblockicon"), for: .normal)
        }
        return cell
        // }
        //        else
        //        {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! MessageTableViewCell
        //            cell.lblMessage.text = "hi jhon i am fine how about you. hope you are doing well and how about your work"
        //
        //            return cell
        //        }
    }
    
    func doActionOnDeleteMessage(sender : UIButton){
        
        CommonUtil.showAlertInSwift_3Format("Are you sure you want to delete this message?", title: "txt_trickychat".localized(), btnCancel: "txt_no".localized(), btnOk: "txt_yes".localized(), crl: self, successBlock: { (obj) in
            
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
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewPostViewController") as! CreateNewPostViewController
        controller.isPostReply = true
        let messageId : String = self.arrMessageList[sender.tag]["messageId"] as! String
        controller.strPostID = messageId
        self.navigationController?.pushViewController(controller, animated: true)
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
