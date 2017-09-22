//
//  PostViewController.swift
//  Tricky
//
//  Created by gopal sara on 19/08/17.
//  Copyright © 2017 gopal sara. All rights reserved.
//

import UIKit

class PostViewController: UIViewController , UITableViewDelegate , UITableViewDataSource, PostMessageDelegate {
    
    @IBOutlet weak var tblPost : UITableView!
    @IBOutlet weak var btnPlus : UIButton!
    var arrPostListData = [Dictionary<String, AnyObject>]()
    @IBOutlet weak var activityView : UIActivityIndicatorView!
    @IBOutlet weak var vwFotter : UIView!
    var totalCount : Int = 0
    var limit : Int = 10
    var offSet : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func decorateUI()
    {
      //  self.tblPost.tableFooterView = UIView()
        self.hideAndShowFotterView(isHideFotter: true, isAnimateActivityInd: false)
        self.tblPost.rowHeight = UITableViewAutomaticDimension
        self.tblPost.estimatedRowHeight = 40
        self.activityView.startAnimating()
        self.doCallWS()
    }
    
    func doCallWS()
    {
        let params = ["version" : "1.0" , "os" : "ios" , "language" : "english","userId":UserManager.sharedUserManager.userId!, "showPostOnlyMyContact" :"0", "filterVulgarMessage" : "\(self.offSet)","limit" : "\(self.limit)","offset" : "0"] as [String : Any]
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "GetAllPost", parameter: params, success: { (responseObject) in
            print(responseObject)
            if (responseObject["status"] as! String  == "1")
            {
                if let resultData : Array<Dictionary<String, Any>> = responseObject["responseData"] as? Array<Dictionary<String, Any>>
              {
                self.totalCount = responseObject["totalRecordCount"] as! Int
                for(_, element) in resultData.enumerated()
                {
                    self.arrPostListData .append(element as [String : AnyObject])
                }
                self.tblPost.reloadData()
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
        
        self.vwFotter.isHidden = isHideFotter
        (isAnimateActivityInd) ? self.activityView.startAnimating() : self.activityView.stopAnimating()
    }
    
    func createNewPost()
    {
        self.doCallWS()
    }

    
    func doActionOnReply(sender : UIButton) {
    let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewPostViewController") as! CreateNewPostViewController
        controller.isPostReply = true
        let postID : String = self.arrPostListData[sender.tag]["postId"] as! String
        controller.strPostID = postID
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func doActionOnShare(sender : UIButton){
        
    }
    
    //MARK: - Tableview delegate and datasource methods
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrPostListData.count
    }
    
    // MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! PostTableViewCell
        cell.decorateTableView(dictData: self.arrPostListData[indexPath.row])
        cell.btnReply.tag = indexPath.row
        cell.btnShare.tag = indexPath.row
        cell.btnReply.addTarget(self, action: #selector(self.doActionOnReply(sender:)), for: .touchUpInside)
        cell.btnShare.addTarget(self, action: #selector(self.doActionOnShare(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func doClickPlus()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewPostViewController") as! CreateNewPostViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastElement = arrPostListData.count - 1
//        if indexPath.row == lastElement{
//        
//        if self.totalCount != self.arrPostListData.count {
//          self.offSet += 10
//          self.createNewPost()
//        self.hideAndShowFotterView(isHideFotter: false, isAnimateActivityInd: true)
//        }
//        else{
//        self.hideAndShowFotterView(isHideFotter: true, isAnimateActivityInd: false)
//        }
//        }
    }
}
