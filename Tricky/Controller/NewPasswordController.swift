//
//  NewPasswordController.swift
//  Tricky
//
//  Created by gopal sara on 19/08/17.
//  Copyright © 2017 gopal sara. All rights reserved.
//

import UIKit

class NewPasswordController: UIViewController {

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
        //57 74 143
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "", strBackButtonImage: BACK_BUTTON, selector: #selector(self.goBack) , color: color(red: 57, green: 74, blue: 143)
)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 57, green: 74, blue: 143)
    }

    func goBack() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
