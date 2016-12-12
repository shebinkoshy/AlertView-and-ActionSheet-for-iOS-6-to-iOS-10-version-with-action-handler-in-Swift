//
//  GlobalManager.swift
//  AlertActionSwift
//
//  Created by Shebin Koshy on 12/2/16.
//  Copyright © 2016 Shebin Koshy. All rights reserved.
//

import Foundation
import UIKit


private let sharedInstance1 = Singleton()
private var arrayAlertActionHandler = Array<Any>()
private var arrayActionSheetActionHandler = Array<Any>()
class Singleton : NSObject, UIAlertViewDelegate, UIActionSheetDelegate {
    class var sharedInstance: Singleton  {
        
        return sharedInstance1;
    }
    
    //MARK: Alert View
    func addAlertActionHandlerToArray(alertActionHandler: AnyObject?){
        if(alertActionHandler == nil)
        {
            arrayAlertActionHandler.append(NSNull())
        }
        else
        {
            arrayAlertActionHandler.append(alertActionHandler as Any)
        }
    }
    
    func showAlert(alertTitle:String?, alertMessage:String?, arrayOfOtherButtonTitles:Array<String>, cancelButtonTitle:String?, presentInViewController:UIViewController, actionHandler:((/**For cancel, buttonIndex will be zero*/_ buttonIndex: Int, _ buttonTitle : String)-> ())?) {
        
        if arrayOfOtherButtonTitles.count == 0 && cancelButtonTitle != nil
        {
            /**
             no buttons
             */
            print("ERROR: No Buttons");
            return;
        }
        if (alertTitle?.characters.count == 0 && alertMessage?.characters.count == 0) || (alertTitle == nil && alertMessage == nil)
        {
            /**
             no title or message
             */
            NSLog("ERROR: No title or message");
            return;
        }
        
        if #available(iOS 8.0, *)
        {
            // UIAlertController
            let alertController = UIAlertController(title:alertTitle, message:alertMessage, preferredStyle:.alert)
            
            for stringButtonTitle in arrayOfOtherButtonTitles
            {
                let action = UIAlertAction(title: stringButtonTitle, style: .default, handler: { (completionHandler) in
                    var indexOfButton = arrayOfOtherButtonTitles.index(of: stringButtonTitle)! as Int
                    indexOfButton += 1
                    self.alertButtonActions(buttonIndex: indexOfButton, buttonTitle: stringButtonTitle, actionHandler: actionHandler as AnyObject)
                })
                alertController.addAction(action)
            }
            
            if(cancelButtonTitle != nil)
            {
                let action = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { (completionHandler) in
                    self.alertButtonActions(buttonIndex: 0, buttonTitle: cancelButtonTitle!, actionHandler: actionHandler as AnyObject)
                })
                alertController.addAction(action)
            }
            
            self.addAlertActionHandlerToArray(alertActionHandler: actionHandler as AnyObject)
            presentInViewController.present(alertController, animated: true, completion: nil)
        }
        else
        {
            // UIAlertView
            let alertView = UIAlertView.init(title: alertTitle, message: alertMessage, delegate: self, cancelButtonTitle: nil)
            for stringButtonTitle in arrayOfOtherButtonTitles
            {
                alertView.addButton(withTitle: stringButtonTitle)
            }
            
            if(cancelButtonTitle != nil)
            {
                alertView.cancelButtonIndex = alertView.addButton(withTitle: cancelButtonTitle)
            }
            
            self.addAlertActionHandlerToArray(alertActionHandler: actionHandler as AnyObject)
            alertView.show()
        }
    }
    
    func alertButtonActions(buttonIndex: Int, buttonTitle: String, actionHandler: AnyObject)  {
        arrayAlertActionHandler.removeLast()
        if actionHandler is NSNull == false
        {
            let completionHandler =  actionHandler as! (_ ind: Int, _ items: String) -> ()
            completionHandler(buttonIndex,buttonTitle)
        }
        
    }
    
    
    //MARK: alertView delegates
    public func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
        var buttonIndexToPass = buttonIndex;
        if (alertView.cancelButtonIndex == buttonIndex && alertView.cancelButtonIndex != 0)
        {
            /**
             cancel button
             */
            buttonIndexToPass = 0;
        }
        if (alertView.cancelButtonIndex != buttonIndex && alertView.cancelButtonIndex != 0)
        {
            /**
             other buttons
             */
            buttonIndexToPass += 1;
        }

        let title = alertView.buttonTitle(at: buttonIndex)
        self.alertButtonActions(buttonIndex: buttonIndexToPass, buttonTitle: title!, actionHandler: arrayAlertActionHandler.last as AnyObject)
    }
    
    
    //MARK: Action Sheet
    func addActionSheetActionHandlerToArray(actionSheetActionHandler: AnyObject?){
        if(actionSheetActionHandler == nil)
        {
            arrayActionSheetActionHandler.append(NSNull())
        }
        else
        {
            arrayActionSheetActionHandler.append(actionSheetActionHandler as Any)
        }
    }
    
    func showActionSheet(actionSheetTitle:String?, arrayOfOtherButtonTitles:Array<String>, cancelButtonTitle:String?,   presentInViewController:UIViewController, actionHandler:((/**For cancel, buttonIndex will be zero*/_ buttonIndex: Int, _ buttonTitle : String)-> ())?) {
        
        if arrayOfOtherButtonTitles.count == 0 && cancelButtonTitle != nil
        {
            /**
             no buttons
             */
            print("ERROR: No Buttons");
            return;
        }
        
        if #available(iOS 8.0, *)
        {
            // UIAlertController
            let actionSheetController = UIAlertController(title:actionSheetTitle, message:nil, preferredStyle:.actionSheet)
            
            for stringButtonTitle in arrayOfOtherButtonTitles
            {
                let action = UIAlertAction(title: stringButtonTitle, style: .default, handler: { (completionHandler) in
                    var indexOfButton = arrayOfOtherButtonTitles.index(of: stringButtonTitle)! as Int
                    indexOfButton += 1
                    self.actionSheetButtonActions(buttonIndex: indexOfButton, buttonTitle: stringButtonTitle, actionHandler: actionHandler as AnyObject)
                })
                actionSheetController.addAction(action)
            }
            
            if(cancelButtonTitle != nil)
            {
                let action = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { (completionHandler) in
                    self.actionSheetButtonActions(buttonIndex: 0, buttonTitle: cancelButtonTitle!, actionHandler: actionHandler as AnyObject)
                })
                actionSheetController.addAction(action)
            }
            
            self.addActionSheetActionHandlerToArray(actionSheetActionHandler: actionHandler as AnyObject)
            presentInViewController.present(actionSheetController, animated: true, completion: nil)
        }
        else
        {
            // UIActionSheet
            
            let actionSheet = UIActionSheet.init(title: actionSheetTitle, delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
            for stringButtonTitle in arrayOfOtherButtonTitles
            {
                actionSheet.addButton(withTitle: stringButtonTitle)
            }
            
            if(cancelButtonTitle != nil)
            {
                actionSheet.cancelButtonIndex = actionSheet.addButton(withTitle: cancelButtonTitle)
            }
            
            self.addActionSheetActionHandlerToArray(actionSheetActionHandler: actionHandler as AnyObject)
            actionSheet.show(in: presentInViewController.view)
        }
    }
    
    func actionSheetButtonActions(buttonIndex: Int, buttonTitle: String, actionHandler: AnyObject)  {
        arrayActionSheetActionHandler.removeLast()
        if actionHandler is NSNull == false
        {
            let completionHandler =  actionHandler as! (_ ind: Int, _ items: String) -> ()
            completionHandler(buttonIndex,buttonTitle)
        }
        
    }
    
    
    //MARK: alertView delegates
    public func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        var buttonIndexToPass = buttonIndex;
        if (actionSheet.cancelButtonIndex == buttonIndex && actionSheet.cancelButtonIndex != 0)
        {
            /**
             cancel button
             */
            buttonIndexToPass = 0;
        }
        if (actionSheet.cancelButtonIndex != buttonIndex && actionSheet.cancelButtonIndex != 0)
        {
            /**
             other buttons
             */
            buttonIndexToPass += 1;
        }
        
        let title = actionSheet.buttonTitle(at: buttonIndex)
        self.actionSheetButtonActions(buttonIndex: buttonIndexToPass, buttonTitle: title!, actionHandler: arrayActionSheetActionHandler.last as AnyObject)
    }
}
