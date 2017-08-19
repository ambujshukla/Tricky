//
//  OTPViewController.swift
//  OTPSection
//
//  Created by gopalsara on 19/08/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//

import UIKit

class VerifyOTPController: UIViewController {

    @IBOutlet weak var tfOtp   : UITextField!
    @IBOutlet weak var btnOTP  : UIButton!
    @IBOutlet weak var btnResend  : UIButton!

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
        self.btnOTP.layer.borderColor = UIColor.white.cgColor
        self.btnOTP.layer.borderWidth = 1.0
        self.btnOTP.layer.masksToBounds = true
        
        self.btnResend.layer.borderColor = UIColor.white.cgColor
        self.btnResend.layer.borderWidth = 1.0
        self.btnResend.layer.masksToBounds = true

        
    }

    @IBAction func doClickReset()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
