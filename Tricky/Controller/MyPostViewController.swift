//
//  MyPostViewController.swift
//  Tricky
//
//

import UIKit
import Localize_Swift
import DZNEmptyDataSet

class MyPostViewController: UIViewController , UITableViewDelegate , UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
{
    @IBOutlet weak var tblPost : UITableView!
    var arrPostListData = [Dictionary<String, AnyObject>]()
    @IBOutlet weak var activityView : UIActivityIndicatorView!
    @IBOutlet weak var vwFotter : UIView!
    var totalCount : Int = 0
    var limit : Int = 10
    var offSet : Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
    }
    
    func decorateUI()
    {
        self.hideAndShowFotterView(isHideFotter: true, isAnimateActivityInd: false)
        self.tblPost.rowHeight = UITableViewAutomaticDimension
        self.tblPost.estimatedRowHeight = 40
        self.activityView.startAnimating()
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "My Post", strBackButtonImage: BACK_BUTTON, selector: #selector(self.goTOBack), color: color(red: 142, green: 110, blue: 137))
        
        
        self.tblPost.emptyDataSetSource = self
        self.tblPost.emptyDataSetDelegate = self

        self.doCallWS()
    }
    func goTOBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 43, green: 167, blue: 139)
        
    }
    
    func doCallWS()
    {
        let params = ["version" : "1.0" , "os" : "ios" , "language" : CommanUtility.getCurrentLanguage(),"userId":CommonUtil.getUserId(), "filterVulgarMessage" :"0", "offset" : "\(self.offSet)","limit" : "\(self.limit)"] as [String : Any]
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "GetMyPost", parameter: params, success: { (responseObject) in
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
    
    func doActionDelete(sender : UIButton)
    {
        CommonUtil.showAlertInSwift_3Format("txt_msg_dlt".localized(), title: "Alert", btnCancel: "txt_no".localized(), btnOk: "txt_yes".localized(), crl: self, successBlock: { (no) in
            let dictData = self.arrPostListData[sender.tag]
            
            let params = ["version" : "1.0" , "os" : "ios" , "language" : CommanUtility.getCurrentLanguage(),"userId":CommonUtil.getUserId(),"postId" :dictData["postId"]!] as [String : Any]
            WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "deletePost", parameter: params, success: { (responseObject) in
                print(responseObject)
                if (responseObject["status"] as! String  == "1")
                {
                    self.arrPostListData .remove(at: sender.tag)
                    self.tblPost.reloadData()
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
    
    func doActionOnShare(sender : UIButton)
    {
        let dictData = self.arrPostListData[sender.tag]
        let shareText = dictData["message"]
        let image = CommanUtility.textToImage(drawText: shareText as! NSString, inImage: #imageLiteral(resourceName: "sharemessage"), atPoint: CGPoint(x : 90 , y : 250))
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! MyPostTableViewCell
        cell.decorateTableView(dictData: self.arrPostListData[indexPath.row])
        cell.btnDelete.tag = indexPath.row
        cell.btnShare.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.doActionDelete(sender:)), for: .touchUpInside)
        cell.btnShare.addTarget(self, action: #selector(self.doActionOnShare(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?
    {
        return  NSAttributedString(string:"txt_no_record".localized(), attributes:
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: Font_Helvetica_Neue, size: 14.0)!])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
