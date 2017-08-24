//
//  PostDetailViewController.swift
//  Tricky
//
//  Created by gopal sara on 22/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import AAPopUp
import Localize_Swift

class PostDetailViewController: UIViewController , UITableViewDelegate , UITableViewDataSource
{
    @IBOutlet weak var tblPosts : UITableView!
    @IBOutlet weak var lblPostCreated : UILabel!
    @IBOutlet weak var lblPost : UILabel!
    @IBOutlet weak var imgBG : UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 106, green: 103, blue: 111)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func decorateUI () {
        
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "txt_post_detail".localized(), strBackButtonImage: BACK_BUTTON, selector: #selector(self.goTOBack), color: color(red: 181, green: 121, blue: 240))

        self.imgBG.backgroundColor = UIColor.black
        self.tblPosts.rowHeight = UITableViewAutomaticDimension;
        self.tblPosts.estimatedRowHeight = 90.0;
        
        self.lblPostCreated.text = "Post Created : 20:25"
        self.lblPostCreated.textColor = UIColor.white
        
        self.lblPost.text = "Sed ut presipiciates undndef iste natus error sit voluptatem accusantium doloremque ludantium, totam rem ipsa"
        self.lblPost.textColor = UIColor.white
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
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! MessageTableViewCell
            cell.lblMessage.text = "Quaue ab illo inventore veritatis et quasi architecto beatae"
            cell.btnReply.addTarget(self, action: #selector(doactionOnReply), for: .touchUpInside)
            return cell
        }
}
