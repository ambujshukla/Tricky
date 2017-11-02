//
//  UserPostViewController.swift
//  Tricky
//
//

import UIKit
import DZNEmptyDataSet

class UserPostViewController: UIViewController, UITableViewDelegate , UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{

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
    
  
    func decorateUI() {
        
       // self.tblMessage.tableFooterView = UIView()
       // self.tblMessage.rowHeight = UITableViewAutomaticDimension;
       // self.tblMessage.estimatedRowHeight = 90.0;
        //57 74 143
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "John Smith", strBackButtonImage: BACK_BUTTON, selector: #selector(self.goTOBack) , color: color(red: 134, green: 146, blue: 216)
        )
        self.tblMessage.emptyDataSetSource = self
        self.tblMessage.emptyDataSetDelegate = self
    }
    
    func goTOBack()
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 134, green: 146, blue: 216)
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
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! UserPostTableViewCell
            return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateNewPostViewController") as! CreateNewPostViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?
    {
        return  NSAttributedString(string:"txt_no_record".localized(), attributes:
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: Font_Helvetica_Neue, size: 14.0)!])
    }
}
