//
//  TodayJobsViewController.swift
//  E-Hired
//
//  Created by Rui Caneira on 9/18/16.
//  Copyright © 2016 Rui Caneira. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchNewJobsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var whereTextField: UITextField!
    @IBOutlet weak var whatTextField: UITextField!
    @IBOutlet weak var loadingView: activityIndicator!
    @IBOutlet weak var tableView: UITableView!
    var jobs:[EHJobs.Detail] = []
    let SEARCH_BTN = 1
    let MAIN_BTN = 2
    let MAP_BTN = 3
    let RESUME_BTN = 4
    let PROFILE_BTN = 5
    @IBOutlet var buttons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(SearchNewJobsViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(SearchNewJobsViewController.keyboardWillDisappear(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    func initView()
    {
        tableView.registerNib(JobCell.cellNib, forCellReuseIdentifier: JobCell.id)
        for i in 0 ..< buttons.count
        {
            buttons[i].layer.cornerRadius = 8
        }
    }
    func loadData()
    {
        let query = whatTextField.text
        let location = whereTextField.text
        if query == ""
        {
            showErrorAlert("query parameter is required")
            return
        }
        if location == ""
        {
            showErrorAlert("location parameter is required")
            return
        }
        self.jobs = []
        let params = [EHNet.SEARCH_WHAT: query as! AnyObject,
                      EHNet.SEARCH_LOCATION: location as! AnyObject]
        self.loadingView.hidden = false
        self.loadingView.startLoading()
        Net.searchJobs(params).onSuccess(callback: {(jobList) -> Void in
            let status = jobList.status
            if status == "ok"
            {
                self.jobs = jobList.detail
                if self.jobs.count != 0
                {
                    self.requestJobViewed()
                }
                
            }else{
                self.showErrorAlert(jobList.error)
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
    func showErrorAlert(message: String)
    {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func dismissKeyboard()
    {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillAppear(notification: NSNotification){
        // Do something here
    }
    
    func keyboardWillDisappear(notification: NSNotification){
        // Do something here
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    @IBAction func action(sender: UIButton) {
        self.view.endEditing(true)
        switch sender.tag {
        case SEARCH_BTN:
            loadData()
        case MAIN_BTN:
            self.navigationController?.popToRootViewControllerAnimated(true)
        case MAP_BTN:
            let mapVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MapTodaysJobsViewController") as! MapTodaysJobsViewController
            self.navigationController?.pushViewController(mapVC, animated: true)
        case RESUME_BTN:
            let resumeVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("YourResumeViewController") as! YourResumeViewController
            self.navigationController?.pushViewController(resumeVC, animated: true)
        case PROFILE_BTN:
            let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("YourProfileViewController") as! YourProfileViewController
            self.navigationController?.pushViewController(profileVC, animated: true)
        default:
            break
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func requestJobViewed()
    {
        var arrayList : [String: AnyObject]
        var list: [JSON] = []//data array
        if (jobs.count > 0)
        {
            for i in 0 ..< jobs.count
            {
                
                arrayList = [
                    EHNet.JOB_VIEW_JOB_SITE: jobs[i].job_site,
                    EHNet.JOB_VIEW_JOB_SITE_ID: jobs[i].job_site_id
                ]
                
                list.append(JSON(arrayList))//append to your list
                
            }
        }
        let params:[String: AnyObject] = [ EHNet.JOB_LIST_KEY: "\(list)"]
        Net.requestServer(EHNet.JOBS_VIEWED_URL, params: params ).onSuccess(callback: {(jobList) -> Void in
            print("success")
            
        }).onFailure(callback: { (_) -> Void in
            
        })
    }

    
}
extension SearchNewJobsViewController: UITableViewDataSource
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(JobCell.id, forIndexPath: indexPath) as! JobCell
        cell.title.text = jobs[indexPath.row].job_title
        cell.company.text = jobs[indexPath.row].job_company
        cell.snippet.text = jobs[indexPath.row].job_snippet
        cell.address.text = jobs[indexPath.row].location_address
        return cell
    }
}
extension SearchNewJobsViewController:UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let url = jobs[indexPath.row].job_link
        if url != ""
        {
            if let link = NSURL(string: url)
            {
                UIApplication.sharedApplication().openURL(link)
            }
        }
    }
}