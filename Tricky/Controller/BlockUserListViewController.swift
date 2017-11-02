//
//  BlockUserListViewController.swift
//  Tricky
//
//

import UIKit
import Localize_Swift
import DZNEmptyDataSet

class BlockUserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var imgBG : UIImageView!
    
    var searchBar : UISearchBar!
    var shouldSearchStart : Bool = false
    
    var arrBlockList = ["Johnson Smith","Kenton","Martin","Prince","Tom Brady","Zack","Sammy","Rhydian"]
    var arrFilteredData = [String]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
        self.configureInitialParameters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 97, green: 118, blue: 138)
    }
    
    func  decorateUI()
    {

        self.tblView.backgroundColor = UIColor.clear
        CommanUtility.createCustomRightButton(self, navBarItem: self.navigationItem, strRightImage: SEARCH_ICON as NSString, select: #selector(doClickSearch))
        self.searchBar = UISearchBar()
        self.searchBar.sizeToFit()
        self.searchBar.placeholder = "txt_search".localized()
        self.searchBar.delegate = self
        self.searchBar.isHidden = true
        self.imgBG.image = UIImage(named : BLOCK_LIST_BG)
        
        CommanUtility.decorateNavigationbarWithBackButtonAndTitle(target: self, leftselect: #selector(doClickBack), strTitle: "txt_block_users".localized(), strBackImag: BACK_BUTTON, strFontName: "Arial", size: 20, color: UIColor.white)
    }
    
    func doClickBack()
    {
       self.navigationController?.popViewController(animated: true)
    }
    func  configureInitialParameters()
    {
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.tableFooterView = UIView()
        self.arrFilteredData = self.arrBlockList
        
        self.tblView.emptyDataSetSource = self
        self.tblView.emptyDataSetDelegate = self
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
        if shouldSearchStart == false
        {
            navigationItem.titleView = self.searchBar
            self.searchBar.isHidden = false
        }else{
            navigationItem.titleView = nil
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
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?
    {
        return  NSAttributedString(string:"txt_no_record".localized(), attributes:
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: Font_Helvetica_Neue, size: 14.0)!])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
