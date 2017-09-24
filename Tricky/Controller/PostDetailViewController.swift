//
//  PostDetailViewController.swift
//  Tricky
//
//  Created by gopal sara on 22/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import Localize_Swift

class PostDetailViewController: UIViewController , UITableViewDelegate , UITableViewDataSource
{
    @IBOutlet weak var tblPosts : UITableView!
    @IBOutlet weak var lblPostCreated : UILabel!
    @IBOutlet weak var lblPost : UILabel!
    @IBOutlet weak var imgBG : UIImageView!
    
    var arrPostDetailListData = [Dictionary<String, AnyObject>]()
    var strPostId : String = ""
    var strPost : String = ""
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
        let params = ["version" : "1.0" , "os" : "ios" , "language" : "english","userId":UserManager.sharedUserManager.userId!, "postId" :self.strPostId, "limit" : "\(self.limit)","offset" : "\(self.offSet)", "showOnlyFav" : "0"] as [String : Any]
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
        
        self.lblPostCreated.text = "Post Created : 20:25"
        self.lblPostCreated.textColor = UIColor.white
        
        self.lblPost.text = self.strPost
        self.lblPost.textColor = UIColor.white
        
        self.tblPosts.rowHeight = UITableViewAutomaticDimension
        self.tblPosts.estimatedRowHeight = 56
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
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.doActionDelete(sender:)), for: .touchUpInside)
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
        let vc = UIActivityViewController(activityItems: [shareText ?? ""], applicationActivities: [])
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
        CommonUtil.showAlertInSwift_3Format("Are you sure you want to delete", title: "Alert", btnCancel: "txt_no".localized(), btnOk: "txt_yes".localized(), crl: self, successBlock: { (no) in
            let dictData = self.arrPostDetailListData[sender.tag]
            
            let params = ["version" : "1.0" , "os" : "ios" , "language" : "english","userId":UserManager.sharedUserManager.userId!,"postId" :dictData["postMessageId"]!] as [String : Any]
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
}
