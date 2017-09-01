//
//  FavouriteViewController.swift
//  Tricky
//
//  Created by gopal sara on 22/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import AAPopUp
class FavouriteViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet weak var tblFav : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func decorateUI () {
        
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "Favourite", strBackButtonImage: BACK_BUTTON, selector: #selector(self.goTOBack), color: color(red: 181, green: 121, blue: 240))
        
        self.tblFav.rowHeight = UITableViewAutomaticDimension;
        self.tblFav.estimatedRowHeight = 90.0;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 181, green: 121, blue: 240)
    }
    
    
    func goTOBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func doactionOnReply()
    {
        let popup: AAPopUp = AAPopUp(popup: .demo2)
        popup.present { popup in
            // MARK:- View Did Appear Here
            popup.dismissWithTag(9)
        }
        
        
    }
    
    //MARK: - Tableview delegate and datasource methods
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    // MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! MessageTableViewCell
            cell.lblMessage.text = "Hi jack how are you whats going on dude"
            cell.btnReply.addTarget(self, action: #selector(doactionOnReply), for: .touchUpInside)
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! MessageTableViewCell
            cell.lblMessage.text = "hi jhon i am fine how about you. hope you are doing well and how about your work"
            
            return cell
        }
    }
    
    
}
