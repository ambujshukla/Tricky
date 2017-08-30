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
   self.tblMessage.tableFooterView = UIView()
        self.tblMessage.rowHeight = UITableViewAutomaticDimension;
        self.tblMessage.estimatedRowHeight = 90.0;
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
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! MessageTableViewCell
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let popup: AAPopUp = AAPopUp(popup: .demo2)
        popup.present { popup in
            // MARK:- View Did Appear Here
            popup.dismissWithTag(9)
        }
        
        
    }
    
    
    
    
  
}
