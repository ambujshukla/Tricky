//
//  HomeViewController.swift
//  Tricky
//
//

import UIKit
import Localize_Swift

class HomeViewController: UIViewController {
    
    var viewPager:ViewPagerController!
    @IBOutlet weak var lblType : UILabel!
    var Vcs = [UIViewController]()
    
    var contactsArray = NSMutableArray()
    var arrMainData = [[String : AnyObject]]()
    
    var tabs = [
        ViewPagerTab(title: "txt_msg".localized(), image: UIImage(named: "fries")),
        ViewPagerTab(title: "txt_chat".localized(), image: UIImage(named: "hamburger"))
        //,
        //    ViewPagerTab(title: "Post", image: UIImage(named: "pint")),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doCustomSetUp()
        NotificationCenter.default.addObserver(self, selector: #selector(doShowAlert), name: Notification.Name("logoutAlert"), object: nil)
        self.doGetContactFromConactBook(isShowLoader: false)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func doShowAlert()
    {
        CommonUtil.showAlertInSwift_3Format("txt_logout1".localized(), title: "txt_trickychat".localized(), btnCancel: "txt_no".localized(), btnOk: "txt_yes".localized(), crl: self, successBlock: { (obj) in
            
            CommonUtil.setBooleanValue("isLogin", value: false)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewIdentifier") as! SignUpViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }) { (obj) in
            print("ok")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 56, green: 192, blue: 110)
    }
    
    func doCustomSetUp(){
        
        self.Vcs  = [self.storyboard?.instantiateViewController(withIdentifier:"HomeMessageController") as!  HomeMessageController
            , self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController ,
              self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController ]
        
        
        let revealViewController: SWRevealViewController? = self.revealViewController()
        if revealViewController != nil {
            CommanUtility.decorateNavigationbarWithRevealToggleButton(target : revealViewController!, strTitle: "txt_trickychat".localized(), strBackButtonImage: "menuicon", selector: #selector(SWRevealViewController.revealToggle(_:)) , controller : self , color:  color(red: 56, green: 152, blue: 108) )
            navigationController?.navigationBar.addGestureRecognizer(revealViewController!.panGestureRecognizer())
        }
        
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        let options = ViewPagerOptions(viewPagerWithFrame: self.view.bounds)
        options.tabType = ViewPagerTabType.basic
        
        options.fitAllTabsInView = true
        options.isEachTabEvenlyDistributed = true
        options.tabViewImageSize = CGSize(width: 20, height: 20)
        options.tabViewTextFont = UIFont.systemFont(ofSize: 16)
        options.tabViewPaddingLeft = 20
        options.tabViewPaddingRight = 20
        options.isTabHighlightAvailable = true
        options.tabViewBackgroundDefaultColor = color(red: 50, green: 181, blue: 119)
        options.tabViewBackgroundHighlightColor = color(red: 50, green: 181, blue: 119)
        viewPager = ViewPagerController()
        viewPager.options = options
        viewPager.dataSource = self
        viewPager.delegate = self
        
        self.addChildViewController(viewPager)
        self.view.addSubview(viewPager.view)
        viewPager.didMove(toParentViewController: self)
        
        
    }
    
    func doGetContactFromConactBook(isShowLoader : Bool){
        if isShowLoader {
            CommonUtil.showLoader()
        }
        DispatchQueue.global(qos: .background).async
            {
                ContactPickerUtils.sharedContactPicker.getContctFromContactBook(target: self) { (contacts, error) in
                    DispatchQueue.main.async {
                        self.contactsArray = contacts
                        DispatchQueue.global(qos: .background).async{
                            self.doCallSyncContactsWS(isShowLoader: isShowLoader)
                        }
                    }
                }
        }
    }
    
    func doCallSyncContactsWS(isShowLoader : Bool)
    {
        var arrayTempContacts = [[String : String]]()
        for model in self.contactsArray
        {
            var dictContactsData = [String : String]()
            let contact: ContactModel
            contact =  model as! ContactModel
            
            for phoneNo in contact.phoneNumbers
            {
                let string = phoneNo.phoneNumber as AnyObject // string starts as "hello[]
                let badchar = CharacterSet(charactersIn: "\"-() ")
                let cleanedstring = string.components(separatedBy: badchar).joined()
                dictContactsData["userNumber"] =  cleanedstring.stringByRemovingWhitespaces as String
                dictContactsData["userName"] = contact.fullName! as String
            }
            arrayTempContacts.append(dictContactsData)
        }
        let data = ["data" : arrayTempContacts]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let theJSONText = String(data: jsonData,
                                     encoding: .utf8)
            
            let dictData = ["version" : "1.0" , "os" : "2" , "language" : CommanUtility.getCurrentLanguage(),"userId":CommonUtil.getUserId(), "requestData" : theJSONText!] as [String : Any]
            WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOSTAndPullToRefresh(isShowLoder :isShowLoader , strURL: kBaseUrl, strServiceName: "SyncContact", parameter: dictData, success: { (obj) in
                if let dictContactsData = obj["responseData"] as? [[String : AnyObject]]
                {
                    self.arrMainData.append(contentsOf: dictContactsData)
                    CommanUtility.saveObjectInPreference(arrData: self.arrMainData, key: "contact")
                    
                }
            }) { (error) in
            }
        } catch {
            print(error.localizedDescription)
        }
    }
 
    
}


extension HomeViewController: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        //        return vc
        

        return self.Vcs[position]
    }
    
    func tabsForPages() -> [ViewPagerTab] {
         tabs = [
            ViewPagerTab(title: "txt_msg".localized(), image: UIImage(named: "fries")),
            ViewPagerTab(title: "txt_chat".localized(), image: UIImage(named: "hamburger"))
            //,
            //    ViewPagerTab(title: "Post", image: UIImage(named: "pint")),
        ]

        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
}

extension HomeViewController: ViewPagerControllerDelegate {
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to page \(index)")
    }
}
