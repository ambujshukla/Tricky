//
//  BlockUserListViewController.swift
//  Tricky
//
//  Created by Shweta Shukla on 20/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit

class BlockUserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tblView : UITableView!
    var searchBar : UISearchBar!
    var shouldSearchStart : Bool = false
    
    var arrBlockList = ["Johnson Smith","Kenton","Martin","Prince","Tom Brady","Zack","Sammy","Rhydian"]
    var arrFilteredData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
        self.configureInitialParameters()
    }
    
    func  decorateUI(){
        self.tblView.backgroundColor = UIColor.clear
        self.view.backgroundColor = UIColor.black
        CommanUtility.createCustomRightButton(self, navBarItem: self.navigationItem, strRightImage: "search", select: #selector(doClickSearch))
        self.searchBar = UISearchBar()
        self.searchBar.sizeToFit()
        self.searchBar.placeholder = "Search"
        self.searchBar.delegate = self
        navigationItem.titleView = self.searchBar
        self.searchBar.isHidden = true
    }
    
    func  configureInitialParameters(){
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.tableFooterView = UIView()
        self.arrFilteredData = self.arrBlockList
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFilteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! BlockUserListTableViewCell
         cell.lblTitle.text = self.arrFilteredData[indexPath.row]
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func doClickSearch(){
        if shouldSearchStart == false{
            self.searchBar.isHidden = false
        }else{
            self.searchBar.isHidden = true
            self.searchBar.text = ""
        }
        shouldSearchStart = !(self.searchBar.isHidden)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let predicate = NSPredicate(format: "SELF contains %@", searchBar.text!)
        self.arrFilteredData = self.arrBlockList.filter { predicate.evaluate(with: $0) }
        
        if (searchBar.text?.isEmpty)! {
            self.arrFilteredData = self.arrBlockList
        }
        self.tblView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
