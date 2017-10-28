//
//  LanguageViewController.swift
//  Tricky
//
//  Created by gopal sara on 20/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import Localize_Swift

class LanguageViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var tblLanguage : UITableView!
    @IBOutlet weak var btnContinue : UIButton!
    var arrData = [String]()
    var index = -1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func decorateUI()
    {
        if Localize.currentLanguage() == "zh-Hant" {
            index = 1
        }else if Localize.currentLanguage() == "es"
        {
        index = 2
        }else if Localize.currentLanguage() == "pt-PT"
        {
            index = 3
        }else{
            index = 0
        }
        
        self.tblLanguage.tableFooterView = UIView()
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "txt_language".localized(), strBackButtonImage: BACK_BUTTON , selector: #selector(self.goTOBack), color: color(red: 107, green: 108, blue: 180))
        
        let revealViewController: SWRevealViewController? = self.revealViewController()
        if revealViewController != nil {
            CommanUtility.decorateNavigationbarWithRevealToggleButton(target : revealViewController!, strTitle: "txt_trickychat".localized(), strBackButtonImage: "menuicon", selector: #selector(SWRevealViewController.revealToggle(_:)) , controller : self , color:  color(red: 56, green: 152, blue: 108) )
            navigationController?.navigationBar.addGestureRecognizer(revealViewController!.panGestureRecognizer())
        }
        self.btnContinue.isHidden = UserDefaults.standard.bool(forKey: "isLanguageSelected")
        
        if (UserDefaults.standard.bool(forKey: "isLanguageSelected") != true)
        {
            self.navigationItem.setLeftBarButton(nil, animated: true)
        }
        
        self.arrData = ["txt.english","txt.chinese","txt.spanish","txt.porugues"]
        self.tblLanguage.separatorColor = color(red: 75, green: 70, blue: 130)
        
        self.btnContinue.setTitle("txt_continue".localized(), for: .normal)
        self.btnContinue.backgroundColor = UIColor.clear
        self.btnContinue.setTitleColor(UIColor.white, for: .normal)
        self.btnContinue.layer.cornerRadius = 5.0
        self.btnContinue.layer.borderWidth = 1.0
        self.btnContinue.layer.borderColor = UIColor.white.cgColor
        
        self.tblLanguage.isScrollEnabled = false
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 106, green: 110, blue: 180)
    }
    
    func goTOBack()
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: - Table View DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrData.count
    }
    
    // MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let label = cell.contentView.viewWithTag(10) as! UILabel!
        label?.text = self.arrData[indexPath.row].localized()
        
        let imgCheck = cell.contentView.viewWithTag(11) as! UIImageView
        imgCheck.isHidden = true
        if indexPath.row == index  {
            imgCheck.isHidden = false
        }
        
        cell.selectionStyle = .none
        label?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == index {
            return
        }
        index = indexPath.row
        
        let alert = UIAlertController(title: "txt_trickychat".localized(), message: "\("txt_change_language".localized()) \(self.arrData[indexPath.row].localized())", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "txt_yes".localized(), style: UIAlertActionStyle.default, handler:
            { action in
                
                switch (self.index) {
                case (0):
                    Localize.setCurrentLanguage("en")
                case (1):
                    Localize.setCurrentLanguage("zh-Hant")
                case (2):
                    Localize.setCurrentLanguage("es")
                case (3):
                    Localize.setCurrentLanguage("pt-PT")
                default:
                    print("")
                }
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.isLanguageChanged = true
                self.title = "txt_language".localized()
                self.tblLanguage.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "txt_no".localized(), style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doClickContinue()
    {
        UserDefaults.standard.set(true, forKey: "isLanguageSelected") //Bool
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewIdentifier") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
