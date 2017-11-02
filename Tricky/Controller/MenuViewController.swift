//
//  MenuViewController.swift
//  Tricky
//
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
    //private var tap: UITapGestureRecognizer!
    
    var controller : UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.controller = self.revealViewController().frontViewController as! UINavigationController!
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.decorateUI()
    }
    
    func decorateUI ()
    {
        // self.tap = UITapGestureRecognizer.init(target: self, action: #selector(doClickProfile(tapG:)))
        //self.tap.delegate = self
        //self.view.addGestureRecognizer(self.tap)
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2
        self.imgProfile.layer.masksToBounds = true
        
        self.lblEmail.textColor = UIColor.white
        self.lblUserName.textColor = UIColor.white
        self.lblUserName.text = CommonUtil.getDataForKey("name") //UserManager.sharedUserManager.name
        self.lblEmail.text = CommonUtil.getDataForKey("userUrl")// UserManager.sharedUserManager.userUrl
        
        if let image = CommanUtility.getImage(userId: CommonUtil.getUserId()) as? UIImage {
            self.imgProfile.image = image
        }
        
        //, "My Post" ,"txt_display_all_anonymous_post".localized()
        self.menuData = ["txt_home".localized() ,"txt_block_users".localized() , "txt_contacts".localized() , "txt_favorite".localized() , "txt_language".localized() , "txt_filter_vulgar".localized() , "txt_block_unauthorized".localized()];
        
        self.tblMenu.tableFooterView = UIView()
        self.lblSent.textColor = UIColor.white
        self.lblReceived.textColor = UIColor.white
        
        self.lblSent.text = "\(String(describing: UserManager.sharedUserManager.sentMsgCount!)) \n\("txt_sent".localized())"
        self.lblReceived.text = "\(String(describing: UserManager.sharedUserManager.receiveMsgCount!)) \n\("txt_received".localized())"
        self.tblMenu.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchValueDidChange(sender:PWSwitch!) {
        
        if sender.tag == 5 {
            if sender.on {
                CommonUtil.setData("filterMessage", value: "1")
            }
            else{
                CommonUtil.setData("filterMessage", value: "0")
            }
            
        }else if sender.tag == 6{
            
            if sender.on {
                CommonUtil.setData("isBlockUser", value: "1")
            }
            else{
                CommonUtil.setData("isBlockUser", value: "0")
            }
            
            
        }else if sender.tag == 7{
            
            if sender.on {
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
        
        if indexPath.row == 5 || indexPath.row == 6  {
            cell.switchPW?.isHidden = false
            if indexPath.row == 5
            {
                if (CommonUtil.filterVulgerMsg() == "1") {
                    cell.switchPW.on = true
                }else{
                    cell.switchPW.on = false
                }
            }
            
            if indexPath.row == 6
            {
                if (CommonUtil.isBlockUser() == "1") {
                    cell.switchPW.on = true
                }else{
                    cell.switchPW.on = false
                }
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
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.isRefreshmsg = true

          //  if appDelegate.isLanguageChanged {
              //  let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeMessageController") as! HomeMessageController
                let contrlHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                let navController = UINavigationController.init()
                navController.setViewControllers([contrlHome], animated: true)
                self.revealViewController().pushFrontViewController(navController, animated: true)
                appDelegate.isLanguageChanged = false
//            }else
//            {
//                self.revealViewController().revealToggle(animated: true)
//                self.revealViewController().pushFrontViewController(self.controller, animated: true)
//            }
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
            //            let controller = self.storyboard?.instantiateViewController(withIdentifier: "MyPostViewController") as! MyPostViewController
            //            let contrlHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            //            let navController = UINavigationController.init()
            //            navController.setViewControllers([contrlHome , controller], animated: true)
            //            self.revealViewController().pushFrontViewController(navController, animated: true)
            
        }else  if (indexPath.row == 7)
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
    
    @IBAction func doClickProfile()
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
    
    @IBAction func doClickShareLink(){
        
        let link = "\("txt_share".localized()) \(self.lblEmail.text!)"
        let shareItems:Array = [link]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        
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
