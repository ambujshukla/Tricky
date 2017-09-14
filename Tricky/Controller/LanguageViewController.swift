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
    
    func decorateUI() {
        
        //  NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
        self.tblLanguage.tableFooterView = UIView()
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "txt_language".localized(), strBackButtonImage: BACK_BUTTON , selector: #selector(self.goTOBack), color: color(red: 107, green: 108, blue: 180))
        
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
        index = indexPath.row
        
        let alert = UIAlertController(title: "txt_trickychat".localized(), message: "txt_change_language \(self.arrData[indexPath.row].localized())", preferredStyle: UIAlertControllerStyle.alert)
        
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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewIdentifier") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
