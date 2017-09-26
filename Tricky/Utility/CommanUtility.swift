//
//  CommanUtility.swift
//  indj_GUI
//
//  Created by gopalsara on 15/07/17.
//  Copyright © 2017 padio. All rights reserved.
//

import UIKit

class CommanUtility: NSObject {
    
    
    class func decorateNavigationbarWithRevealToggleButton(target : UIViewController , strTitle : String , strBackButtonImage : String , selector : Selector , controller : UIViewController , color : UIColor )
    {
        
        controller.navigationController?.navigationBar.barTintColor = color
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: strBackButtonImage), for: UIControlState())
        btnLeftMenu.addTarget(target, action: selector, for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        controller.navigationItem.leftBarButtonItem = barButton
        controller.navigationItem.title = strTitle
        controller.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
    }
    
    class func decorateNavigationbarWithBackButton(target : UIViewController , strTitle : String , strBackButtonImage : String , selector : Selector , color : UIColor )
    {
        
        target.navigationController?.navigationBar.barTintColor = color
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: strBackButtonImage), for: UIControlState())
        btnLeftMenu.addTarget(target, action: selector, for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        target.navigationItem.leftBarButtonItem = barButton
        target.navigationItem.title = strTitle
        target.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        
    }
    
//    class func decorateNavigationbar(target : UIViewController , strTitle : String) {
//        
//        target.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        target.navigationController?.navigationBar.shadowImage = UIImage()
//        target.navigationController?.navigationBar.isTranslucent = true
//        target.navigationController?.view.backgroundColor = UIColor.clear
//        UINavigationBar.appearance().clipsToBounds = true
//        target.navigationController?.interactivePopGestureRecognizer?.delegate = nil
//        target.navigationController?.navigationBar.backgroundColor = UIColor.clear
//        target.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
//        target.navigationController?.setNavigationBarHidden(false, animated: true)
//        target.navigationItem.title = strTitle
//    }
    
    class func createCustomRightButtons(_ target:AnyObject,navBarItem:UINavigationItem,strLeftImage:NSString,leftselect:Selector,strRightImage:NSString,select:Selector)
    {
        
        let buttonleft: UIButton = UIButton(type: .custom)
        buttonleft.frame = CGRect(x: 40, y: 0, width: 40, height: 40)
        buttonleft.setImage(UIImage(named:strLeftImage as String), for: UIControlState())
        buttonleft.addTarget(target, action: leftselect, for: UIControlEvents.touchUpInside)
        let leftBarButtonItemEdit: UIBarButtonItem = UIBarButtonItem(customView: buttonleft)
        
        let buttonEdit: UIButton = UIButton(type: .custom)
        buttonEdit.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        buttonEdit.setImage(UIImage(named:strRightImage as String), for: UIControlState())
        buttonEdit.addTarget(target, action: select, for: UIControlEvents.touchUpInside)
        let rightBarButtonItemEdit: UIBarButtonItem = UIBarButtonItem(customView: buttonEdit)
        // add multiple right bar button items
        navBarItem.setRightBarButtonItems(NSArray(objects: rightBarButtonItemEdit,leftBarButtonItemEdit) as NSArray as? [UIBarButtonItem], animated: true)
        // uncomment to add single right bar button item
        // self.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
    }
    
    
    class func createCustomRightButton(_ target:AnyObject,navBarItem:UINavigationItem,strRightImage:NSString,select:Selector)
    {
        let buttonEdit: UIButton = UIButton(type: .custom)
        buttonEdit.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        buttonEdit.setImage(UIImage(named:strRightImage as String), for: UIControlState())
        buttonEdit.addTarget(target, action: select, for: UIControlEvents.touchUpInside)
        let rightBarButtonItemEdit: UIBarButtonItem = UIBarButtonItem(customView: buttonEdit)
        // add multiple right bar button items
        //  navBarItem.setRightBarButtonItems(NSArray(objects: rightBarButtonItemEdit) as NSArray as? [UIBarButtonItem], animated: true)
        // uncomment to add single right bar button item
        navBarItem.setRightBarButton(rightBarButtonItemEdit, animated: false)
    }
    
    
    
    class func decorateNavigationbarWithBackButtonAndTitle (target : UIViewController , leftselect : Selector , strTitle : String , strBackImag : String , strFontName : String , size : CGFloat , color : UIColor) {
        
        target.navigationController?.view.backgroundColor = UIColor.white
        target.navigationItem.title =  strTitle as String
        let  font = UIFont(name: strFontName , size:size)!
        target.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: font,  NSForegroundColorAttributeName: color]
        
        let buttonBack: UIButton = UIButton(type: .custom)
        buttonBack.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        buttonBack.setImage(UIImage(named:strBackImag as String), for: UIControlState())
        buttonBack.addTarget(target, action: leftselect, for: UIControlEvents.touchUpInside)
        let rightBarButtonItemEdit: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        target.navigationItem.setLeftBarButton(rightBarButtonItemEdit, animated: false)
        
        target.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

    }
    
    class func doDefaultSettingOfNavigationBar (controller : UIViewController) {
        controller.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        controller.navigationController?.navigationBar.shadowImage = nil
        controller.navigationController?.navigationBar.isTranslucent = false
        controller.navigationController?.navigationBar.clipsToBounds = false
    }
    
    
    class func saveObjectInPreference (arrData : [String] , key : String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(arrData, forKey: key)
        userDefaults.synchronize()
    }
    class func getObjectFromPrefrence (key  : String) -> [String] {
        
        let userDefaults = UserDefaults.standard
        
        if let data = (userDefaults.object(forKey: key)){
            return data as! [String]
        }
        else
        {
            return []
        }
    }
    
    class func removeObjectFromPrefrence(key : String) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }
    
    class func doChangeTimeFormat(time : String, firstFormat : String, SecondFormat : String) -> String
    {
        let time = time
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = firstFormat
        
        var fullDate = dateFormatter.date(from: time)
        
        dateFormatter.dateFormat = SecondFormat
        
        var time2 = dateFormatter.string(from: fullDate!)
        
        return time2
    }
    
    class func saveImageDocumentDirectory(userId : String, img : UIImage){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("image_\(userId).png")
       // let image = UIImage(named: ("image \(userId).png"))
        print(paths)
        let imageData = UIImageJPEGRepresentation(img, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
   class func getImage(userId : String) -> UIImage{
        var img = UIImage()
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("image_\(userId).png")
        if fileManager.fileExists(atPath: imagePAth){
            img = UIImage(contentsOfFile: imagePAth)!
        }else{
            img = UIImage(named : "avatar.png")!
    }
        return img
    }
    
   class func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}


