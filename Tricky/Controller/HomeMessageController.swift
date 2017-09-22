//
//  MessageViewController.swift
//  Tricky
//
//  Created by gopal sara on 19/08/17.
//  Copyright © 2017 gopal sara. All rights reserved.
//

import UIKit
import AAPopUp


class HomeMessageController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var tblMessage : UITableView!
    @IBOutlet weak var btnPlus : UIButton!
    var arrMessageList = [Dictionary<String, AnyObject>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
        self.doGetMessageList()
        // Do any additional setup after loading the view.
    }
    
    func doGetMessageList()
    {
        self.view.endEditing(true)
        //UpdateProfile
        let dictData = ["version" : "1.0" , "os" : "ios" , "language" : "english","userId":"19","filterVulgar" : "0","messageForOnlyRegisterUser":"0","offset":"0","limit" : "10","showOnlyFavorite":"0"] as [String : Any]
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "getRecSentList", parameter: dictData , success: { (obj) in
            
            if (obj["status"] as! String == "1")
            {
                if let result : Array<Dictionary<String, Any>> = obj["responseData"] as? Array<Dictionary<String, Any>>
                {
                    for(_, element) in result.enumerated()
                    {
                        self.arrMessageList .append(element as [String : AnyObject])
                    }
                    self.tblMessage.reloadData()
                }
            }
            print("this is object \(obj)")
        }) { (error) in
            CommonUtil.showTotstOnWindow(strMessgae: (error?.localizedDescription)!)
            
        }
    }
    
    func doCallServiceForFavouriteMessage(){
        
        let dictParam = ["userId" : UserManager.sharedUserManager.userId!] as [String : Any]
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl , strServiceName: "favoriteMsg", parameter: dictParam , success: { (obj) in
            print("this is object \(obj)")
        }) { (error) in
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func decorateUI () {
        
        
        let options = AAPopUp.globalOptions
        options.storyboardName = "Main"
        options.dismissTag = 9

        
        self.tblMessage.tableFooterView = UIView()
        self.tblMessage.rowHeight = UITableViewAutomaticDimension;
        self.tblMessage.estimatedRowHeight = 90.0;
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
        
       // if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! MessageTableViewCell
            cell.decorateTableViewCell(dictData: self.arrMessageList[indexPath.row])
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
        
        let popupVC = storyboard?.instantiateViewController(withIdentifier: "PopupViewController") as! PopupViewController
        view.addSubview(popupVC.view)
        addChildViewController(popupVC)
    }
    
    @IBAction func doClickPlus()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
