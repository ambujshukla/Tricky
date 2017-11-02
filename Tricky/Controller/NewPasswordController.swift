//
//  NewPasswordController.swift
//  Tricky
//
//

import UIKit

class NewPasswordController: UIViewController {

    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var txtCnfPassword : UITextField!
    @IBOutlet weak var btnSubmit : UIButton!
    @IBOutlet weak var imgBG : UIImageView!

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
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "txt_new_password".localized(), strBackButtonImage: BACK_BUTTON, selector: #selector(self.goBack) , color: color(red: 57, green: 74, blue: 143))
        
        self.imgBG.image = UIImage(named : NEW_PASSWORD)

            self.txtPassword.attributedPlaceholder = NSAttributedString(string: "txt_password".localized(),
                                                                        attributes: [NSForegroundColorAttributeName: UIColor.white])
            
            self.txtCnfPassword.attributedPlaceholder = NSAttributedString(string: "txt_cnf_mobile".localized(),
            attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        self.btnSubmit.setTitle("txt_submit".localized(), for: .normal)
        self.btnSubmit.backgroundColor = UIColor.white
        self.btnSubmit.setTitleColor(UIColor.darkGray, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 129, green: 153, blue: 219)
    }

    func goBack() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doClickSubmit()
    {
      
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
