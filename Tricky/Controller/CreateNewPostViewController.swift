//
//  CreateNewPostViewController.swift
//  Tricky
//
//  Created by gopal sara on 24/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit

class CreateNewPostViewController: UIViewController {

    @IBOutlet weak var btnCreate : UIButton!
    
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
        self.btnCreate.layer.borderColor = UIColor.white.cgColor
        self.btnCreate.layer.borderWidth = 1.0
        self.btnCreate.layer.masksToBounds = true
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "John smith", strBackButtonImage: BACK_BUTTON, selector: #selector(self.goTOBack), color: color(red: 147, green: 108, blue: 234))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 147, green: 108, blue: 234)
    }
    
    func goTOBack()
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func doClickSend()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
