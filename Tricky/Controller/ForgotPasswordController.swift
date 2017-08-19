//
//  ForgotPasswordController.swift
//  OTPSection
//
//  Created by gopalsara on 19/08/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//

import UIKit

class ForgotPasswordController: UIViewController {
    
    
    @IBOutlet weak var tfMobile   : UITextField!
    @IBOutlet weak var btnReset  : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func decorateUI (){
        self.btnReset.layer.borderColor = UIColor.white.cgColor
        self.btnReset.layer.borderWidth = 1.0
        self.btnReset.layer.masksToBounds = true
    }
    
    
    @IBAction func doActionOnResetButton()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPController") as! VerifyOTPController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
