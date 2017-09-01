//
//  PostViewController.swift
//  Tricky
//
//  Created by gopal sara on 19/08/17.
//  Copyright © 2017 gopal sara. All rights reserved.
//

import UIKit

class PostViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {

    @IBOutlet weak var tblPost : UITableView!
    var isComeFromHome : Bool!
    @IBOutlet weak var topConstraint : NSLayoutConstraint!
    
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
        
        self.tblPost.tableFooterView = UIView()
    }
    
    //MARK: - Tableview delegate and datasource methods
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
    }
    
    // MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as UITableViewCell
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserPostViewController") as! UserPostViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
