//
//  LogInViewController.swift
//  E-Hired
//
//  Created by Rui Caneira on 11/6/16.
//  Copyright © 2016 Rui Caneira. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var loadingView: activityIndicator!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    var showKeyboard = false
    override func viewDidLoad() {
        GoogleAnalitics.send(GoogleAnalitics.Login.ScreenName)
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(LogInViewController.handleTap))
        self.scrollView.addGestureRecognizer(tapGesture);
        logInBtn.layer.cornerRadius = 8
    }
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWasShown), name: UIKeyboardWillShowNotification, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardHide), name: UIKeyboardWillHideNotification, object: nil)
    }

    @IBAction func loginAction(sender: AnyObject) {
        if(emailTxt.text == "")
        {
            showAlertMessage("Please enter email address!", title: "Input Error")
            return
        }
        if(pwdText.text == "")
        {
            showAlertMessage("Please enter password!",title: "Input Error")
            return
        }
        if(!FBoxHelper.isValidEmail(emailTxt.text!))
        {
//            showAlertMessage("Email Validation Error", title: "Input Error")
//            return
        }
        self.loadingView.hidden = false
        self.loadingView.startLoading()
        Net.getAPI_Key(emailTxt.text, password: pwdText.text).onSuccess(callback: {(Key) -> Void in
            let apiKey = Key.api_key
            if apiKey != ""
            {
                let userDefault = NSUserDefaults.standardUserDefaults()
                userDefault.setObject(apiKey, forKey: "apikey")
                userDefault.synchronize()
                    self.gotoMainViewController(self)
            }else{
                 self.showAlertMessage("Invalid user or password! Please try again!", title: "Error")
            }
            self.loadingView.completeLoading(true)
            self.loadingView.hidden = true
        }).onFailure(callback: { (_) -> Void in
            self.loadingView.completeLoading(true)
            self.loadingView.hidden = true
            self.showAlertMessage("Internet connection error!", title: "Error")
           
        })

        
    }
    func handleTap()
    {
        self.view.endEditing(true)
    }
    func keyboardWasShown()
    {
        if(!showKeyboard)
        {
            showKeyboard = true
            scrollView.contentSize = CGSizeMake(self.view.frame.size.width, scrollView.frame.size.height + 216)
        }
    }
    func keyboardHide()
    {
       if showKeyboard
       {
        self.view.endEditing(true)
        scrollView.contentSize = CGSizeMake(0, 0);
        showKeyboard = false
        }
    }
    func gotoMainViewController(sender: AnyObject)
    {
        let mainNav = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainNav") as! UINavigationController
        self.presentViewController(mainNav, animated: false, completion: nil)
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if (textField == emailTxt)
        {
            scrollView.contentOffset = CGPointMake(0, 60)
        }else if (textField == pwdText){
            scrollView.contentOffset = CGPointMake(0, 90)
        }
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == emailTxt)
        {
            pwdText.becomeFirstResponder()
        }else if(textField == pwdText)
        {
            self.view.endEditing(true)
        }
        return true
    }
    func showAlertMessage(message: String!, title: String!)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}
