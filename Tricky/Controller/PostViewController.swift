//
//  PostViewController.swift
//  Tricky
//
//  Created by gopal sara on 19/08/17.
//  Copyright © 2017 gopal sara. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class PostViewController: UIViewController , UITableViewDelegate , UITableViewDataSource, PostMessageDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var tblPost : UITableView!
    @IBOutlet weak var btnPlus : UIButton!
    
    var arrPostListData = [[String : AnyObject]]()
    {
        didSet{
            self.tblPost.reloadData()
        }
    }
    @IBOutlet weak var activityView : UIActivityIndicatorView!
    @IBOutlet weak var vwFotter : UIView!
    
    var totalCount : Int = 0
    var limit : Int = 10
    var offSet : Int = 0
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()

    
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
        self.tblPost.addSubview(self.refreshControl)
        self.hideAndShowFotterView(isHideFotter: true, isAnimateActivityInd: false)
        self.tblPost.rowHeight = UITableViewAutomaticDimension
        self.tblPost.estimatedRowHeight = 40
        
        self.tblPost.emptyDataSetSource = self
        self.tblPost.emptyDataSetDelegate = self
        
        self.activityView.startAnimating()
        self.doCallWS(isComeFromPullToRefresh : false)
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.doCallWS(isComeFromPullToRefresh : true)
        refreshControl.endRefreshing()
    }

    func doCallWS(isComeFromPullToRefresh : Bool)
    {
        let params = ["version" : "1.0" , "os" : "ios" , "language" : "english","userId":UserManager.sharedUserManager.userId!, "showPostOnlyMyContact" :"0", "filterVulgarMessage" : "\(self.offSet)","limit" : "\(self.limit)","offset" : "0"] as [String : Any]
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOSTAndPullToRefresh(isShowLoder: !isComeFromPullToRefresh , strURL: kBaseUrl, strServiceName: "GetAllPost", parameter: params, success: { (responseObject) in
            print(responseObject)
            if (responseObject["status"] as! String  == "1")
            {
                if let resultData : Array<Dictionary<String, Any>> = responseObject["responseData"] as? Array<Dictionary<String, Any>>
              {
                self.totalCount = responseObject["totalRecordCount"] as! Int
                if (isComeFromPullToRefresh){
                    self.arrPostListData.removeAll()
                }
                for(_, element) in resultData.enumerated()
                {
                    self.arrPostListData .append(element as [String : AnyObject])
                }
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
        self.doCallWS(isComeFromPullToRefresh: false)
    }
    
    func doActionOnReply(sender : UIButton) {
    let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewPostViewController") as! CreateNewPostViewController
        controller.isPostReply = true
        let postID : String = self.arrPostListData[sender.tag]["postId"] as! String
        controller.strPostID = postID
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func doActionOnShare(sender : UIButton)
    {
        let dictData = self.arrPostListData[sender.tag]
        let shareText = dictData["message"]
        let vc = UIActivityViewController(activityItems: [shareText ?? ""], applicationActivities: [])
        present(vc, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dictData = self.arrPostListData[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        vc.strPostId = dictData["postId"] as! String
        vc.strPost = dictData["message"] as! String
        vc.strPostTime = CommanUtility.doChangeTimeFormat(time: (dictData["time"] as? String)!, firstFormat: "yyyy-MM-dd HH:mm:ss", SecondFormat: "dd-MM-yyyy")
        
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
        if indexPath.row == lastElement{
        
        if self.totalCount != self.arrPostListData.count {
          self.offSet += 10
          self.createNewPost()
        self.hideAndShowFotterView(isHideFotter: false, isAnimateActivityInd: true)
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
