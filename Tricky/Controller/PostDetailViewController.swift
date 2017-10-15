//
//  PostDetailViewController.swift
//  Tricky
//
//  Created by gopal sara on 22/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import Localize_Swift
import DZNEmptyDataSet

class PostDetailViewController: GAITrackedViewController , UITableViewDelegate , UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    @IBOutlet weak var tblPosts : UITableView!
    @IBOutlet weak var lblPostCreated : UILabel!
    @IBOutlet weak var lblPost : UILabel!
    @IBOutlet weak var imgBG : UIImageView!
    
    var arrPostDetailListData = [Dictionary<String, AnyObject>]()
    var strPostId : String = ""
    var strPost : String = ""
    var strPostTime : String = ""
    var totalCount : Int = 0
    var limit : Int = 10
    var offSet : Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
        self.doCallWS()
    }
    
    func doCallWS()
    {
        let params = ["version" : "1.0" , "os" : "ios" , "language" : "english","userId":CommonUtil.getUserId(), "postId" :self.strPostId, "limit" : "\(self.limit)","offset" : "\(self.offSet)", "showOnlyFav" : "0"] as [String : Any]
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "GetPostReplyList", parameter: params, success: { (responseObject) in
            print(responseObject)
            if (responseObject["status"] as! String  == "1")
            {
                if let resultData : Array<Dictionary<String, Any>> = responseObject["responseData"] as? Array<Dictionary<String, Any>>
                {
                    self.totalCount = responseObject["totalRecordCount"] as! Int
                    for(_, element) in resultData.enumerated()
                    {
                        self.arrPostDetailListData .append(element as [String : AnyObject])
                    }
                    self.tblPosts.reloadData()
                }
                else {
                    self.hideAndShowFotterView(isHideFotter: true, isAnimateActivityInd: false)
                }
            }
        }) { (error) in
            print("")
        }
    }
    
    
    func hideAndShowFotterView(isHideFotter : Bool , isAnimateActivityInd : Bool){
        
        // self.vwFotter.isHidden = isHideFotter
        // (isAnimateActivityInd) ? self.activityView.startAnimating() : self.activityView.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Set screen name.
        self.screenName = "Post Detail"
        self.navigationController?.navigationBar.barTintColor = color(red: 106, green: 103, blue: 111)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func decorateUI ()
    {
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "txt_post_detail".localized(), strBackButtonImage: BACK_BUTTON, selector: #selector(self.goTOBack), color: color(red: 181, green: 121, blue: 240))
        
        self.imgBG.image = UIImage(named: POST_DETAIL_BG)
        self.tblPosts.rowHeight = UITableViewAutomaticDimension;
        self.tblPosts.estimatedRowHeight = 82.0;
        
        self.lblPostCreated.text = "Post Created : \(strPostTime)"
        self.lblPostCreated.textColor = UIColor.white
        
        self.lblPost.text = self.strPost
        self.lblPost.textColor = UIColor.white
        
        self.tblPosts.rowHeight = UITableViewAutomaticDimension
        self.tblPosts.estimatedRowHeight = 56
        
        self.tblPosts.emptyDataSetSource = self
        self.tblPosts.emptyDataSetDelegate = self
    }
    
    func goTOBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func doactionOnReply()
    {
        
    }
    
    //MARK: - Tableview delegate and datasource methods
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrPostDetailListData.count
    }
    
    // MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! PostDetailTableViewCell
        cell.decorateTableView(dictData: self.arrPostDetailListData[indexPath.row])
        cell.btnReply.tag = indexPath.row
        cell.btnShare.tag = indexPath.row
        cell.btnReply.addTarget(self, action: #selector(self.doActionOnReply(sender:)), for: .touchUpInside)
        cell.btnShare.addTarget(self, action: #selector(self.doActionOnShare(sender:)), for: .touchUpInside)
        cell.btnFavorite.tag = indexPath.row
        cell.btnFavorite.addTarget(self, action: #selector(self.doActionOnFavouriteButton(sender:)), for: .touchUpInside)
        cell.btnBlock.tag = indexPath.row

        cell.btnBlock.addTarget(self, action: #selector(self.doActionOnBlockButton(sender:)), for: .touchUpInside)

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserPostAnswerViewController") as! UserPostAnswerViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func doActionOnShare(sender : UIButton)
    {
        let dictData = self.arrPostDetailListData[sender.tag]
        let shareText = dictData["message"]
        let image = CommanUtility.textToImage(drawText: shareText as! NSString, inImage: #imageLiteral(resourceName: "sharemessage"), atPoint: CGPoint(x : 90 , y : 250))
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    func doActionOnReply(sender : UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewPostViewController") as! CreateNewPostViewController
        controller.isPostReply = true
        let postID : String = self.arrPostDetailListData[sender.tag]["postMessageId"] as! String
        controller.strPostID = postID
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func doActionDelete(sender : UIButton)
    {
        CommonUtil.showAlertInSwift_3Format("txt_msg_dlt".localized(), title: "Alert", btnCancel: "txt_no".localized(), btnOk: "txt_yes".localized(), crl: self, successBlock: { (no) in
            let dictData = self.arrPostDetailListData[sender.tag]
            
            let params = ["version" : "1.0" , "os" : "ios" , "language" : "english","userId":CommonUtil.getUserId(),"postId" :dictData["postMessageId"]!] as [String : Any]
            WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "deletePost", parameter: params, success: { (responseObject) in
                print(responseObject)
                if (responseObject["status"] as! String  == "1")
                {
                    self.arrPostDetailListData .remove(at: sender.tag)
                    self.tblPosts.reloadData()
                }
                else {
                    self.hideAndShowFotterView(isHideFotter: true, isAnimateActivityInd: false)
                }
            }) { (error) in
                print("")
            }
        }) { (no) in
            
        }
    }
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?
    {
        return  NSAttributedString(string:"txt_no_record".localized(), attributes:
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: Font_Helvetica_Neue, size: 14.0)!])
    }
    
    func doActionOnFavouriteButton(sender : UIButton) {
        
        var dictData = self.arrPostDetailListData[sender.tag]
        let messageID = dictData["postMessageId"]! as! String
//        let type = dictData["type"]! as! NSNumber
        let type = "1"
        
        let dictParam = ["userId" : CommonUtil.getUserId() , "messageId" : messageID , "type" : "\(type)"] as [String : Any]
        print(dictParam)
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl , strServiceName: "favoriteMsg", parameter: dictParam , success: { (responseObject) in
            print("this is object \(responseObject)")
            if(responseObject["status"] as! String == "1"){
                
                if let resultData : Array<Dictionary<String, Any>> = responseObject["responseData"] as? Array<Dictionary<String, Any>> {
                    
                    dictData["isFavorite"] = resultData[0]["isFavorite"]  as AnyObject
                    self.arrPostDetailListData[sender.tag] = dictData
                    self.tblPosts.reloadData()
                }
                self.arrPostDetailListData[sender.tag] = dictData
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
        
        var dictData = self.arrPostDetailListData[sender.tag]
        let messageID = dictData["postMessageId"]! as! String
        
        let dictParam = ["userId" : CommonUtil.getUserId() , "messageId" : messageID] as [String : Any]
        print(dictParam)
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl , strServiceName: "blockMessageUser", parameter: dictParam , success: { (responseObject) in
            print("this is object \(responseObject)")
            if(responseObject["status"] as! String == "1"){
                
                if let resultData : Array<Dictionary<String, Any>> = responseObject["responseData"] as? Array<Dictionary<String, Any>> {
                    
                    dictData["isUserBlock"] = resultData[0]["isBlocked"]  as AnyObject
                    self.arrPostDetailListData[sender.tag] = dictData
                    self.tblPosts.reloadData()
                }
                self.arrPostDetailListData[sender.tag] = dictData
            }
            else
            {
                CommonUtil.showTotstOnWindow(strMessgae: responseObject["responseMessage"] as! String)
            }
        }) { (error) in
            
        }
    }

}
