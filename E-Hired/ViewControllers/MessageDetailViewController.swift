//
//  MessageDetailsViewController.swift
//  E-Hired
//
//  Created by Rui Caneira on 1/5/17.
//  Copyright © 2017 Rui Caneira. All rights reserved.
//

import UIKit
class MessageDetailViewController: UIViewController {
    
    var message: EHMessage.Detail!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var sentLabel: UILabel!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var replyMsgTV: UITextView!
    @IBOutlet weak var loadingView: activityIndicator!
    
    @IBOutlet weak var replyView: UIView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        GoogleAnalitics.send(GoogleAnalitics.MessageDetailScreen.ScreenName)
        initView()
    }
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    func initView()
    {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(MessageDetailViewController.handleTap))
        self.view.addGestureRecognizer(tapGesture);
        for i in 0 ..< buttons.count
            
        {
            
            buttons[i].layer.cornerRadius = 8
            
        }
        replyView.layer.cornerRadius = 8
        replyView.layer.borderWidth = 2
        replyView.layer.borderColor = buttons[0].backgroundColor!.CGColor
        replyView.hidden = true
        if let message = self.message
            
        {
            messageTV.text = message.message_body
            
            subjectLabel.text = message.message_subject
            
            fromLabel.text = message.message_from
            
            sentLabel.text = message.message_date
            
            let params = ["message_id": message.message_id as AnyObject]
            
            self.loadingView.hidden = false
            
            self.loadingView.startLoading()
            
            Net.setMessageOpened(params).onSuccess(callback: {(message) -> Void in
                
                let status = message.status
                
                if status == "ok"
                    
                {
                    
                    print("success")
                    
                }else{
                    
                    //                self.showErrorAlert(message.error)
                    
                }
                
                self.loadingView.completeLoading(true)
                
                self.loadingView.hidden = true
                
            }).onFailure(callback: { (error) -> Void in
                
                self.loadingView.completeLoading(true)
                
                self.loadingView.hidden = true
                
                print("failed")
                
            })
        }
        
    }
    
    @IBAction func msgReplyAction(sender: AnyObject) {
        if replyMsgTV.text == ""
        {
            showAlertMessage("Please enter message!", title: "Warning")
            return
        }
        replyView.hidden = true
        let params = ["message_id": message.message_id as AnyObject,
                      "message_body": replyMsgTV.text as AnyObject]
        
        self.loadingView.hidden = false
        replyMsgTV.text = ""
        
        self.loadingView.startLoading()
        
        Net.replyMessage(params).onSuccess(callback: {(message) -> Void in
            
            let status = message.status
            
            if status == "ok"
            {
                
                print("success")
                
            }else{
                
                //                self.showErrorAlert(message.error)
                
            }
            
            self.loadingView.completeLoading(true)
            
            self.loadingView.hidden = true
            
        }).onFailure(callback: { (error) -> Void in
            
            self.loadingView.completeLoading(true)
            
            self.loadingView.hidden = true
            
            print("failed")
            
        })

    }
    @IBAction func closeAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    @IBAction func replyAction(sender: AnyObject) {
        
        replyView.hidden = false
        
    }
    func handleTap()
    {
        self.view.endEditing(true)
    }
    func showAlertMessage(message: String!, title: String!)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}

