//
//  HomeViewController.swift
//  Tricky
//
//  Created by gopal sara on 18/08/17.
//  Copyright © 2017 gopal sara. All rights reserved.
//

import UIKit

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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func doCustomSetUp(){
        
        let revealViewController: SWRevealViewController? = self.revealViewController()
        if revealViewController != nil {
        CommanUtility.decorateNavigationbarWithRevealToggleButton(target : revealViewController!, strTitle: "Home", strBackButtonImage: "menuicon", selector: #selector(SWRevealViewController.revealToggle(_:)) , controller : self , color:  color(red: 107, green: 198, blue: 108) )
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
