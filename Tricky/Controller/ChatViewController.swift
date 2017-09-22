//
//  ChatViewController.swift
//  Tricky
//
//  Created by gopal sara on 19/08/17.
//  Copyright © 2017 gopal sara. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController  , UITableViewDataSource , UITableViewDelegate{
    
    @IBOutlet weak var tblChat : UITableView!
    
    var chatData =  Array<Dictionary<String , AnyObject>>(){
        didSet {
            self.tblChat.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func decorateUI() {
        
        self.tblChat.tableFooterView = UIView()
        self.doCallWebServiceForGetChatList()
    }
    
    
    func doCallWebServiceForGetChatList(){
        

        
        let dictData = ["userId" : UserManager.sharedUserManager.userId! , "os" : "2" , "version" : "1.0" , "language" : "english" , "limit" : "10" , "offset" : "0"] as [String : Any]
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl , strServiceName: "chatList", parameter: dictData, success: { (obj) in
            print(obj)
            if (obj["status"] as! String == "1"){
                let chatData = obj["responseData"]
                self.chatData = chatData as! Array<Dictionary<String, AnyObject>>
            }
            else{
                CommonUtil.showTotstOnWindow(strMessgae: obj["responseMessage"] as! String)
            }
            
            
        }) { (error) in
            
        }
        
    }
    
    //MARK: - Tableview delegate and datasource methods
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.chatData.count
    }
    
    // MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! ChatListCell
        cell.doSetDataOnCell(dictData: self.chatData[indexPath.row])
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatDetailViewIdentifier") as! ChatDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
