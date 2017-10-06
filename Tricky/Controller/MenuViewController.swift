//
//  MenuViewController.swift
//  Tricky
//
//  Created by gopal sara on 18/08/17.
//  Copyright © 2017 gopal sara. All rights reserved.
//

import UIKit
import Localize_Swift
import PWSwitch

class MenuViewController: UIViewController , UITableViewDataSource , UITableViewDelegate, UIGestureRecognizerDelegate {
    
    var menuData = [String]()
    @IBOutlet weak var tblMenu : UITableView!
    @IBOutlet weak var  imgProfile  : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblEmail : UILabel!
    @IBOutlet weak var lblSent : UILabel!
    @IBOutlet weak var lblReceived : UILabel!
    private var tap: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.decorateUI()
    }
    
    func decorateUI ()
    {
        self.tap = UITapGestureRecognizer.init(target: self, action: #selector(doClickProfile(tapG:)))
        self.tap.delegate = self
        self.view.addGestureRecognizer(self.tap)
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2
        self.imgProfile.layer.masksToBounds = true
        
        self.lblEmail.textColor = UIColor.white
        self.lblUserName.textColor = UIColor.white
        self.lblUserName.text = UserManager.sharedUserManager.name
        self.lblEmail.text = UserManager.sharedUserManager.userUrl

        if let image = CommanUtility.getImage(userId: UserManager.sharedUserManager.userId!) as? UIImage {
            self.imgProfile.image = image
        }

        self.menuData = ["Home".localized() ,"txt_block_users".localized() , "contacts" , "Favorite" , "language", "My Post" , "Filter vulgar messages" , "Block Unauthorised user","Display all anonymous post" , "Logout"];
        
        self.tblMenu.tableFooterView = UIView()
        self.lblSent.textColor = UIColor.white
        self.lblReceived.textColor = UIColor.white
        
        self.lblSent.text = "\(String(describing: UserManager.sharedUserManager.sentMsgCount!)) \nSent"
        self.lblReceived.text = "\(String(describing: UserManager.sharedUserManager.receiveMsgCount!)) \nRecieved"
        self.tblMenu.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchValueDidChange(sender:UISwitch!) {

        if sender.tag == 6 {
            if sender.isOn {
            CommonUtil.setData("filterMessage", value: "1")
            }
            else{
                CommonUtil.setData("filterMessage", value: "0")
            }
            
        }else if sender.tag == 7{
            
            if sender.isOn {
                CommonUtil.setData("isBlockUser", value: "1")
            }
            else{
                CommonUtil.setData("isBlockUser", value: "0")
            }

            
        }else if sender.tag == 8{
            
            if sender.isOn {
                CommonUtil.setData("isAnonymous", value: "1")
            }
            else{
                CommonUtil.setData("isAnonymous", value: "0")
            }
        }
        self.tblMenu.reloadData()
    
    }
    
    // MARK: - Table View DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.menuData.count
    }
    
    // MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTableViewCell
        
        if indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 {
            cell.switchPW?.isHidden = false
            if indexPath.row == 6 && (CommonUtil.filterVulgerMsg() == "1") {
              cell.switchPW.on = true
            }else{
                cell.switchPW.on = false
            }
            
            if indexPath.row == 7 && (CommonUtil.isBlockUser() == "1") {
                cell.switchPW.on = true
            }else{
                cell.switchPW.on = false
            }
            if indexPath.row == 8 && (CommonUtil.isAnonymous() == "1") {
                cell.switchPW.on = true
            }else{
                cell.switchPW.on = false
            }
        }
        else
        {
            cell.switchPW?.isHidden = true
            
        }
        cell.lblTitle?.text = self.menuData[indexPath.row]
        cell.selectionStyle = .none
        cell.switchPW.tag = indexPath.row
        cell.switchPW.addTarget(self, action: #selector(self.switchValueDidChange(sender:)), for: .valueChanged)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        else if (indexPath.row == 6) {
        //
        //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        //            let contrlHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        //            let navController = UINavigationController.init()
        //            navController.setViewControllers([contrlHome , vc], animated: true)
        //            self.revealViewController().pushFrontViewController(navController, animated: true)
        //        }
        
        if (indexPath.row == 0) {
            
            self.revealViewController().revealToggle(animated: true)
            
          
            let contrlHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let navController = UINavigationController.init()
            navController.setViewControllers([contrlHome], animated: true)
            self.revealViewController().pushFrontViewController(navController, animated: true)
        }else if (indexPath.row == 1)
        {
            self.doNavigateToContactsView(showContactsFrom: 1)
        }
        else if (indexPath.row == 2)
        {
          self.doNavigateToContactsView(showContactsFrom: 2)
        }else if (indexPath.row == 3) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteViewController") as! FavouriteViewController
            let contrlHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let navController = UINavigationController.init()
            navController.setViewControllers([contrlHome , vc], animated: true)
            self.revealViewController().pushFrontViewController(navController, animated: true)
        }else if(indexPath.row == 4)
        {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
            let contrlHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let navController = UINavigationController.init()
            navController.setViewControllers([contrlHome , controller], animated: true)
            self.revealViewController().pushFrontViewController(navController, animated: true)
        }else if(indexPath.row == 5)
        {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MyPostViewController") as! MyPostViewController
            let contrlHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let navController = UINavigationController.init()
            navController.setViewControllers([contrlHome , controller], animated: true)
            self.revealViewController().pushFrontViewController(navController, animated: true)
            
        }else  if (indexPath.row == 9)
        {
            //  self.dismiss(animated: true, completion: nil)
            self.revealViewController().revealToggle(animated: true)
            NotificationCenter.default.post(name: Notification.Name("logoutAlert"), object: nil)
        }
    }
    
    func doNavigateToContactsView(showContactsFrom : Int)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        vc.isFromMenu = true
        vc.contactShowFrom = showContactsFrom
        let contrlHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let navController = UINavigationController.init()
        navController.setViewControllers([contrlHome , vc], animated: true)
        self.revealViewController().pushFrontViewController(navController, animated: true)
    }
    
    @IBAction func doClickProfile(tapG : UITapGestureRecognizer)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewIdentifier") as! ProfileViewController
        let contrlHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let navController = UINavigationController.init()
        navController.setViewControllers([contrlHome , vc], animated: true)
        self.revealViewController().pushFrontViewController(navController, animated: true)
    }
    
    @IBAction func doClickCopyLink()
    {
        UIPasteboard.general.string = self.lblEmail.text
        CommonUtil.showTotstOnWindow(strMessgae: "txt_copied".localized())
    }
    
    @IBAction func doClickShareLink()
    {
        let shareText = self.lblEmail.text
        let vc = UIActivityViewController(activityItems: [shareText ?? ""], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    //Mark TapGestureDelegate
    // UIGestureRecognizerDelegate method
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.tblMenu) == true {
            return false
        }
        return true
    }
}
