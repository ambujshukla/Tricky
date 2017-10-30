//
//  CommanUtility.swift
//  indj_GUI
//
//  Created by gopalsara on 15/07/17.
//  Copyright © 2017 padio. All rights reserved.
//

import UIKit
import Localize_Swift

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
        buttonEdit.adjustsImageWhenHighlighted = false
        let rightBarButtonItemEdit: UIBarButtonItem = UIBarButtonItem(customView: buttonEdit)
        // add multiple right bar button items
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
    
    class func doCheckValidationForSignUp(){
        
        
    }
    
    class func saveObjectInPreference (arrData : [[String : AnyObject]] , key : String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(arrData, forKey: key)
        userDefaults.synchronize()
    }
    class func getObjectFromPrefrence (key  : String) -> [[String : AnyObject]] {
        
        let userDefaults = UserDefaults.standard
        
        if let data = (userDefaults.object(forKey: key)){
            return data as! [[String : AnyObject]]
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
    
    
    class func convertAStringIntodDte(time : String , formate : String) -> Date{
        let time = time
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.dateFormat = formate
        if let fullDate = dateFormatter.date(from: time)
        {
            return fullDate
        }
        return Date()
    }
    
    class func convertUTCToLocal(dateTime:String) -> String {
        print(dateTime)
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        //
        //        let dt = dateFormatter.date(from: date)
        //        dateFormatter.timeZone = TimeZone.current
        //        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //
        //        return dateFormatter.string(from: dt!)
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let date = dateFormatter.date(from: dateTime)// create   date from string
        
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date!)
        return timeStamp
    }
    
    class func doChangeTimeFormat(time : String, firstFormat : String, SecondFormat : String) -> String
    {
        let time = time
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = firstFormat
        
        let fullDate = dateFormatter.date(from: time)
        
        dateFormatter.dateFormat = SecondFormat
        
        let time2 = dateFormatter.string(from: fullDate!)
        
        return time2
    }
    //    class func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage
    //    {
    //        let image = UIImage(named: "bear.jpeg")
    //        return image!
    //    }
    
    class func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage
    {
        
        let textColor = UIColor.black
        let textFont = UIFont(name: "Roboto-Medium", size: 50)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSParagraphStyleAttributeName: style ,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width : image.size.width , height : image.size.height)))
        
        let rect = CGRect(origin: point, size: CGSize(width : image.size.width-280 , height : image.size.height-230))
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    class func imageFrom(text: String , size:CGSize) -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 36)!, NSForegroundColorAttributeName: UIColor.white, NSParagraphStyleAttributeName: paragraphStyle]
            
            text.draw(with: CGRect(x: 0, y: size.height / 2, width: size.width, height: size.height), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
            
        }
        return img
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
    
    class func getDateFromString(format : String, time : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: time)
        return date!
    }
    
    class func getCurrentLanguage() -> String
    {
        var strLang = "1"
        if Localize.currentLanguage() == "en"{
            strLang = "1"
        }
        else if Localize.currentLanguage() == "zh-Hant"{
            strLang = "2"
        }
        else if Localize.currentLanguage() == "es"{
            strLang = "3"
        }
        else if Localize.currentLanguage() == "pt-PT"{
            strLang = "4"
        }
        return strLang
    }
}




