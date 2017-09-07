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
        let dictData = ["version" : "1.0" , "os" : "ios" , "language" : "english","userId":"19", "receiverId" : "20", "lastMessageDateTime" :""] as [String : Any]
        
        WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "getChatMessageList", parameter: dictData , success: { (obj) in
            
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
                
//                if let dictResponseData = obj["responseData"] as? [[String : AnyObject]]
//                {
//                    print(dictResponseData)
//                    for(_, element) in dictResponseData.enumerated()
//                    {
//                        self.arrMessageList .append(element as [String : AnyObject])
//                    }
//                }
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
    
    func decorateUI () {
        self.tblMessage.tableFooterView = UIView()
        self.tblMessage.rowHeight = UITableViewAutomaticDimension;
        self.tblMessage.estimatedRowHeight = 90.0;
    }
    
    
    //MARK: - Tableview delegate and datasource methods
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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
        
        //        let popup: AAPopUp = AAPopUp(popup: .demo2)
        //        popup.present { popup in
        //            // MARK:- View Did Appear Here
        //            popup.dismissWithTag(9)
        //        }
    }
    
    @IBAction func doClickPlus()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
