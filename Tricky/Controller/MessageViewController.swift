//
//  MessageViewController.swift
//  OTPSection
//
//  Created by gopalsara on 19/08/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    @IBOutlet weak var txtViewComment : UITextView!
    @IBOutlet weak var btnSend : UIButton!
    
    
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
        self.btnSend.layer.borderColor = UIColor.white.cgColor
        self.btnSend.layer.borderWidth = 1.0
        self.btnSend.layer.masksToBounds = true
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
