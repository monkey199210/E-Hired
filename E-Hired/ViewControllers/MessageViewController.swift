//
//  MessageViewController.swift
//  E-Hired
//
//  Created by Rui Caneira on 1/5/17.
//  Copyright © 2017 Rui Caneira. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    var messageList: [EHMessage.Detail] = []
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: activityIndicator!
    
    let MAIN_PAGE_BTN = 1
    let YOUR_PROFILE_BTN = 2
    let YOUR_RESUME_BTN = 3
    
    var reloadFlag = true
    var messageCount = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleAnalitics.send(GoogleAnalitics.MessageScreen.ScreenName)
        tableView.registerNib(MessageCell.cellNib, forCellReuseIdentifier: MessageCell.id)
        for i in 0 ..< buttons.count
        {
            buttons[i].layer.cornerRadius = 8
        }
        
    }
    override func viewDidAppear(animated: Bool) {
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        loadMessages()
    }
    func loadMessages()
    {
        self.messageList = []
        let params = ["start": "0" as AnyObject,
                      "count": "10" as AnyObject]
        self.loadingView.hidden = false
        self.loadingView.startLoading()
        Net.getMessages(params).onSuccess(callback: {(message) -> Void in
            let status = message.status
            if status == "ok"
            {
                self.messageList = message.detail
                
            }else{
//                self.showErrorAlert(message.error)
            }
            self.tableView.reloadData()
            self.loadingView.completeLoading(true)
            self.loadingView.hidden = true
        }).onFailure(callback: { (error) -> Void in
            self.loadingView.completeLoading(true)
            self.loadingView.hidden = true
            self.tableView.reloadData()
        })

    }

    @IBAction func action(sender: AnyObject) {
        switch sender.tag {
        case MAIN_PAGE_BTN:
            GoogleAnalitics.send(GoogleAnalitics.MessageScreen.ScreenName, category: GoogleAnalitics.MessageScreen.Category, action: GoogleAnalitics.MessageScreen.Action, label: GoogleAnalitics.MessageScreen.MAINPAGEBUTTON)
            
            self.navigationController?.popToRootViewControllerAnimated(true)
        case YOUR_PROFILE_BTN:
            GoogleAnalitics.send(GoogleAnalitics.MessageScreen.ScreenName, category: GoogleAnalitics.MessageScreen.Category, action: GoogleAnalitics.MessageScreen.Action, label: GoogleAnalitics.MessageScreen.PROFILEBUTTON)
            
            let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("YourProfileViewController") as! YourProfileViewController
            self.navigationController?.pushViewController(profileVC, animated: true)
        case YOUR_RESUME_BTN:
            GoogleAnalitics.send(GoogleAnalitics.MessageScreen.ScreenName, category: GoogleAnalitics.MessageScreen.Category, action: GoogleAnalitics.MessageScreen.Action, label: GoogleAnalitics.MessageScreen.RESUMEBUTTON)
            
            let resumeVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("YourResumeViewController") as! YourResumeViewController
            self.navigationController?.pushViewController(resumeVC, animated: true)
        default:
            break
        }
        
    }
    //
}
// MARK: -
// MARK: UITableView Data Source

extension MessageViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(MessageCell.id, forIndexPath: indexPath) as! MessageCell
        let message = messageList[indexPath.row]
        if(message.message_opened == "1")
        {
            cell.msgImg.image = UIImage(named: "messageopen")
            cell.dateLabel.textColor = UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 1.0)
            cell.msgLabel.textColor = UIColor(red: 117/255.0, green: 117/255.0, blue: 117/255.0, alpha: 1.0)
        }else{
            cell.msgImg.image = UIImage(named: "messageunread")
            cell.dateLabel.textColor = UIColor(red: 32/255.0, green: 32/255.0, blue: 32/255.0, alpha: 1.0)
            cell.msgLabel.textColor = UIColor(red: 32/255.0, green: 32/255.0, blue: 32/255.0, alpha: 1.0)
        }
        cell.dateLabel.text = message.message_date
        cell.msgLabel.text = message.message_subject
        
        
        return cell
    }
    
}

// MARK: -
// MARK: UITableView Delegate

extension MessageViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

