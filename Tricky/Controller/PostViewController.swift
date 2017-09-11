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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
        self.doCallWS()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func decorateUI()
    {
        self.tblPost.tableFooterView = UIView()
        self.tblPost.rowHeight = UITableViewAutomaticDimension
        self.tblPost.estimatedRowHeight = 40
    }
    
    func doCallWS()
    {
        let params = ["version" : "1.0" , "os" : "ios" , "language" : "english","userId":"19", "showPostOnlyMyContact" :"0", "filterVulgarMessage" : "0","limit" : "10","offset" : "0"] as [String : Any]
        WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "GetAllPost", parameter: params, success: { (responseObject) in
            print(responseObject)
            if (responseObject["status"] as! String  == "1")
            {
                if let resultData : Array<Dictionary<String, Any>> = responseObject["responseData"] as? Array<Dictionary<String, Any>>
              {
                self.arrPostListData.removeAll()
                for(_, element) in resultData.enumerated()
                {
                    self.arrPostListData .append(element as [String : AnyObject])
                }
                self.tblPost.reloadData()
              }
            }
        }) { (error) in
            print("")
        }
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
    
    func createNewPost()
    {
      self.doCallWS()
    }
}
