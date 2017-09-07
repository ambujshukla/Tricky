//
//  LanguageViewController.swift
//  Tricky
//
//  Created by gopal sara on 20/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit

class LanguageViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {
    
    @IBOutlet weak var tblLanguage : UITableView!
    var arrData = [[String : String]]()
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
        
        self.tblLanguage.tableFooterView = UIView()
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "Language", strBackButtonImage: BACK_BUTTON , selector: #selector(self.goTOBack), color: color(red: 107, green: 108, blue: 180))
        
        self.arrData = [["language" : "English" , "isSelected" :"1"] , ["language" : "Chinese" , "isSelected" : "0" ], ["language" : "Spanish" , "isSelected" : "0" ] ,["language" : "Portuguese" , "isSelected" : "0" ]]
        
        
        self.tblLanguage.separatorColor = color(red: 75, green: 70, blue: 130)
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
        label?.text = self.arrData[indexPath.row]["language"]
        if self.arrData[indexPath.row]["isSelected"] == "1"{
            cell.accessoryType = .checkmark
        }
        else
        {
            cell.accessoryType = .none
        }
        label?.textColor = UIColor.white
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.arrData[indexPath.row]["isSelected"] == "0"{
           self.arrData[indexPath.row]["isSelected"] = "1"
        }
        else{
            self.arrData[indexPath.row]["isSelected"] = "0"
   
        }
        
    self.tblLanguage.reloadData()
        if indexPath.row == 5 {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
