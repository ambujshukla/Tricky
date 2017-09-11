//
//  HomeViewController.swift
//  Tricky
//
//  Created by gopal sara on 18/08/17.
//  Copyright © 2017 gopal sara. All rights reserved.
//

import UIKit
import Localize_Swift

class HomeViewController: UIViewController {
    
    var viewPager:ViewPagerController!
    @IBOutlet weak var lblType : UILabel!
    var tabs = [
        ViewPagerTab(title: "Message", image: UIImage(named: "fries")),
        ViewPagerTab(title: "Chat", image: UIImage(named: "hamburger")),
        ViewPagerTab(title: "Post", image: UIImage(named: "pint")),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doCustomSetUp()
        NotificationCenter.default.addObserver(self, selector: #selector(doShowAlert), name: Notification.Name("logoutAlert"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    func doShowAlert()
    {
        CommonUtil.showAlertInSwift_3Format("txt_logout".localized(), title: "txt_trickychat".localized(), btnCancel: "txt_no".localized(), btnOk: "txt_yes".localized(), crl: self, successBlock: { (obj) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewIdentifier") as! LoginViewController
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
}


extension HomeViewController: ViewPagerControllerDataSource {
    
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        //        return vc
        
        let vcs  = [self.storyboard?.instantiateViewController(withIdentifier:"HomeMessageController") as!  HomeMessageController
            , self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController ,
              self.storyboard?.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController ]
        
        return vcs[position]
        
    }
    
    func tabsForPages() -> [ViewPagerTab] {
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
