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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
        self.doGetMessageList(isComeFromPullToRefresh:  false)
    }
    
    
    func doGetMessageList(isComeFromPullToRefresh : Bool)
    {
        self.view.endEditing(true)
        let dictData = ["version" : "1.0" , "os" : "ios" , "language" : "english","userId":UserManager.sharedUserManager.userId!,"filterVulgar" : "0","messageForOnlyRegisterUser":"0","offset":"0","limit" : "10","showOnlyFavorite":"0"] as [String : Any]
        
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
        
        self.doCallServiceForFavouriteMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 181, green: 121, blue: 240)
    }
    
    
    func goTOBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func doactionOnReply()
    {
        let popup: AAPopUp = AAPopUp(popup: .demo2)
        popup.present { popup in
            // MARK:- View Did Appear Here
            popup.dismissWithTag(9)
        }
        
        
    }
    
    
    func doCallServiceForFavouriteMessage(){
        
        let dictParam = ["userId" : UserManager.sharedUserManager.userId!] as [String : Any]
         WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl , strServiceName: "favoriteMsg", parameter: dictParam , success: { (obj) in
        print("this is object \(obj)")
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
        
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! MessageTableViewCell
            cell.decorateTableViewCell(dictData: self.arrMessageList[indexPath.row])
            cell.btnfavourite.addTarget(self, action: #selector(self.doCallServiceForFavouriteMessage(sender:)), for: .touchUpInside)
            cell.selectionStyle = .none
            cell.btnReply.addTarget(self, action: #selector(doactionOnReply), for: .touchUpInside)
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! MessageTableViewCell
            cell.lblMessage.text = "hi jhon i am fine how about you. hope you are doing well and how about your work"
            
            return cell
        }
    }
    
    func doCallServiceForFavouriteMessage(sender : UIButton)
    {
        let dictParam = ["userId" : UserManager.sharedUserManager.userId!] as [String : Any]
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl , strServiceName: "favoriteMsg", parameter: dictParam , success: { (obj) in
            print("this is object \(obj)")
        }) { (error) in
            
        }
    }
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?
    {
        return  NSAttributedString(string:"txt_no_record".localized(), attributes:
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: Font_Helvetica_Neue, size: 14.0)!])
    }
    
}
