//
//  Contant.swift
//  JudlauApp
//
//  Created by Reena on 30/01/20.
//  Copyright © 2020 sam. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SwiftMessages

let appDelegate = UIApplication.shared.delegate as! AppDelegate

//@available(iOS 13.0, *)
//let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

//UserDefault Keys
//var DB_EmpDetail = "dbEmpDetail"

var BASE_URL = "http://myprojectdemonstration.com/development/spiritworkcard" //development.

let commonSkyBlueColor : UIColor = UIColor(red: 181/255.0, green: 221/255.0, blue: 247/255.0, alpha: 1)
let commonDarkBlueColor : UIColor = UIColor(red: 34/255.0, green: 92/255.0, blue: 155/255.0, alpha: 1)
let commonBlackColor : UIColor = UIColor(red: 78/255.0, green: 80/255.0, blue: 82/255.0, alpha: 1)
let commonGreenColor : UIColor = UIColor(red: 68/255.0, green: 160/255.0, blue: 34/255.0, alpha: 1)
let commonScreenBgColor : UIColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)

let commonRedColor : UIColor = UIColor(red: 234/255.0, green: 34/255.0, blue: 46/255.0, alpha: 1)

//var activityView: NVActivityIndicatorView!


//1. setup for multiple storyboard.
enum AppStoryboard:String {
    case Main,Home,CategorySubMenu,MyTaskSubMenu,ProjectSubMenu
    
    var instance:UIStoryboard{
        return UIStoryboard(name: self.rawValue, bundle: .main)
    }
    
    func viewController<T:UIViewController>(viewControllerClass:T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
}


extension UIViewController
{
    class var storyboardID : String
    {
        return "\(self)"
    }
    
    static func intantiateFromAppStoryboard(appStoryboard : AppStoryboard) -> Self
    {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
   
    
    
    //for add method of loading indicator view.
//    static func showLoadingIndicator(view : UIView){
//           if activityView == nil{
//               activityView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60), type: NVActivityIndicatorType.lineScalePulseOut, color: UIColor.systemBlue, padding: 0.0)
//            activityView.isHidden = false
//               // add subview
//               view.addSubview(activityView)
//               // autoresizing mask
//               activityView.translatesAutoresizingMaskIntoConstraints = false
//
//               // constraints
//            view.addConstraint(NSLayoutConstraint(item: activityView!, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0))
//            view.addConstraint(NSLayoutConstraint(item: activityView!, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0))
//           }
//
//        activityView.startAnimating()
//       }
//
//      static func stopLoadingIndicator()
//       {
//           activityView.stopAnimating()
//       }
}
//end


//2. Set Orientation controller by controller.
struct AppUtility {
    
//    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
//
//        if let delegate = UIApplication.shared.delegate as? AppDelegate {
//            delegate.orientationLock = orientation
//        }
//    }
//
//    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
//    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
//
//        self.lockOrientation(orientation)
//
//        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
//        UINavigationController.attemptRotationToDeviceOrientation()
//    }
    
    static func showMsg(style : SwiftMessages.PresentationStyle, theme : Theme, strTitle : String , strMsg : String)
    {
        appDelegate.msgConfig.presentationStyle = style
        appDelegate.msgView.configureTheme(theme)
        appDelegate.msgView.configureContent(title: strTitle, body: strMsg, iconText: "🤔")
        
        // Show the message.
        SwiftMessages.show(config: appDelegate.msgConfig, view: appDelegate.msgView)
    }
}


