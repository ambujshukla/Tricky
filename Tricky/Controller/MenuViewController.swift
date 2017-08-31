//
//  MenuViewController.swift
//  Tricky
//
//  Created by gopal sara on 18/08/17.
//  Copyright © 2017 gopal sara. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {

    var menuData = [String]()
    @IBOutlet weak var tblMenu : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
        // Do any additional setup after loading the view.
    }

    func decorateUI () {
        
        self.menuData = ["Block users" , "contacts" , "Favorite" , "language" , "Filter to vulger message" , "Only Register user messgae" , "Logout"];
        self.tblMenu.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.menuData.count
    }
    
    // MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let label = cell.contentView.viewWithTag(10) as! UILabel!
        let swOnOff = cell.contentView.viewWithTag(20) as! UISwitch!
        
        if indexPath.row == 4 || indexPath.row == 5 {
            swOnOff?.isHidden = false
        }
        else
        {
            swOnOff?.isHidden = true
        }

        label?.text = self.menuData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 6 {
        self.dismiss(animated: true, completion: nil)
        }
        else if (indexPath.row == 3){
            
       let controller = self.storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        let contrlHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let navController = UINavigationController.init()
        navController.setViewControllers([contrlHome , controller], animated: true)
        self.revealViewController().pushFrontViewController(navController, animated: true)
        }
        else if (indexPath.row == 1) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
            let contrlHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let navController = UINavigationController.init()
            navController.setViewControllers([contrlHome , vc], animated: true)
            self.revealViewController().pushFrontViewController(navController, animated: true)
        }
       
        else if (indexPath.row == 2) {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteViewController") as! FavouriteViewController
            let contrlHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let navController = UINavigationController.init()
            navController.setViewControllers([contrlHome , vc], animated: true)
            self.revealViewController().pushFrontViewController(navController, animated: true)
        }

            
        else if (indexPath.row == 0) {
          
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlockUserListViewIdentifier") as! BlockUserListViewController
            let contrlHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let navController = UINavigationController.init()
            navController.setViewControllers([contrlHome , vc], animated: true)
            self.revealViewController().pushFrontViewController(navController, animated: true)
        }

    }
    @IBAction func doClickProfile()
    {
       let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewIdentifier") as! ProfileViewController
        let contrlHome = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let navController = UINavigationController.init()
        navController.setViewControllers([contrlHome , vc], animated: true)
        self.revealViewController().pushFrontViewController(navController, animated: true)
    }

}
