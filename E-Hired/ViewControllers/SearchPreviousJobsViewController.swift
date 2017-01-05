//
//  TodayJobsViewController.swift
//  E-Hired
//
//  Created by Rui Caneira on 9/18/16.
//  Copyright © 2016 Rui Caneira. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON
class SearchPreviousJobsViewController: UIViewController {
    let BTN_5 = 1
    let BTN_10 = 2
    let BTN_15 = 3
    let BTN_20 = 4
    let TABLE_EXPEND_BTN = 5
    let MAP_EXTEND_BTN = 6
    let MAIN_BTN = 7
    let PROFILE_BTN = 8
    let RESUME_BTN = 9
    
    @IBOutlet weak var loadingView: activityIndicator!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    var jobs:[EHJobs.Detail] = []
    
    var mapExpendFlag = false
    var tableExpendFlag = false
    @IBOutlet weak var mapButtonImg: UIImageView!
    @IBOutlet weak var tableButtonImg: UIImageView!
    
    
    
    @IBOutlet var buttons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleAnalitics.send(GoogleAnalitics.PreviousJobsScreen.ScreenName)
        self.initView()
        self.initData()
    }
    func initView()
    {
        
        tableView.registerNib(JobCell.cellNib, forCellReuseIdentifier: JobCell.id)
        for i in 0 ..< buttons.count
        {
            buttons[i].layer.cornerRadius = 8
        }
        self.mapView.delegate = self
    }
    func initData()
    {
//        let date = self.subDaysFromNow(-5)
        loadData("4")
    }
    func loadData(date: String)
    {
        self.loadingView.hidden = false
        self.loadingView.startLoading()
        Net.getJobs(date).onSuccess(callback: {(jobList) -> Void in
            let status = jobList.status
            if status == "ok"
            {
                self.jobs = jobList.detail
                if self.jobs.count != 0 {
                    self.requestJobViewed()
                }
                self.tableView.reloadData()
                self.setupPins()
            }
            self.loadingView.completeLoading(true)
            self.loadingView.hidden = true
        }).onFailure(callback: { (_) -> Void in
            self.loadingView.completeLoading(true)
            self.loadingView.hidden = true
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var locationMarker: GMSMarker!
    func setupPins()
    {
        var first = 0
        self.mapView.clear()
        for i in 0 ..< jobs.count
        {
            if let latitude = Double(jobs[i].location_latitude)
            {
                if let longitude = Double(jobs[i].location_longitude)
                {
                    first += 1
                    if first == 1
                    {
                        let camera = GMSCameraPosition.cameraWithLatitude(latitude,
                                                                          longitude:longitude, zoom:6)
                        self.mapView.camera = camera
                        
                    }
                    let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
                    setuplocationMarker(coordinate, index: i)
                }
            }
        }
        
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
    func setuplocationMarker(coordinate: CLLocationCoordinate2D, index:Int) {
        
        let maker = GMSMarker(position: coordinate)
        maker.title = jobs[index].job_title
        maker.map = mapView
        maker.appearAnimation = kGMSMarkerAnimationPop
        maker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        maker.flat = true
        
    }
    @IBAction func action(sender: UIButton) {
        let imgMin = UIImage(named: "reduceBtnMin")
        let imgMax = UIImage(named: "reduceBtnMax")
        var date: String!
        switch sender.tag {
        case BTN_5:
//            date = self.subDaysFromNow(-5)
            date = "4"
        case BTN_10:
//            date = self.subDaysFromNow(-10)
            date = "9"
        case BTN_15:
//            date = self.subDaysFromNow(-15)
            date = "14"
        case BTN_20:
//            date = self.subDaysFromNow(-20)
            date = "19"
        case RESUME_BTN:
            GoogleAnalitics.send(GoogleAnalitics.PreviousJobsScreen.ScreenName, category: GoogleAnalitics.PreviousJobsScreen.Category, action: GoogleAnalitics.PreviousJobsScreen.Action, label: GoogleAnalitics.PreviousJobsScreen.RESUMEBUTTON)
            let resumeVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("YourResumeViewController") as! YourResumeViewController
            self.navigationController?.pushViewController(resumeVC, animated: true)
        case PROFILE_BTN:
            GoogleAnalitics.send(GoogleAnalitics.PreviousJobsScreen.ScreenName, category: GoogleAnalitics.PreviousJobsScreen.Category, action: GoogleAnalitics.PreviousJobsScreen.Action, label: GoogleAnalitics.PreviousJobsScreen.PROFILEBUTTON)
            let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("YourProfileViewController") as! YourProfileViewController
            self.navigationController?.pushViewController(profileVC, animated: true)
        case MAIN_BTN:
            GoogleAnalitics.send(GoogleAnalitics.PreviousJobsScreen.ScreenName, category: GoogleAnalitics.PreviousJobsScreen.Category, action: GoogleAnalitics.PreviousJobsScreen.Action, label: GoogleAnalitics.PreviousJobsScreen.MAINPAGEBUTTON)
            self.navigationController?.popToRootViewControllerAnimated(true)
        case TABLE_EXPEND_BTN:
            if tableExpendFlag && mapExpendFlag
            {
                self.tableViewHeightConstraint.constant = 0
                tableExpendFlag = false
                self.mapViewTopConstraint.constant = 20
                mapExpendFlag = false
            }else if tableExpendFlag && !mapExpendFlag{
                self.tableViewHeightConstraint.constant = -20
                tableExpendFlag = false
                self.mapViewTopConstraint.constant = 20
                mapExpendFlag = false
                
            }else if mapExpendFlag && !tableExpendFlag{
                self.tableViewHeightConstraint.constant = self.containView.frame.height/2 - 10
                tableExpendFlag = true
                self.mapViewTopConstraint.constant = 20
                mapExpendFlag = false
            }
            else {
                self.tableViewHeightConstraint.constant = self.containView.frame.height/2 - 10
                tableExpendFlag = true
                self.mapViewTopConstraint.constant = 20
                
            }
        case MAP_EXTEND_BTN:
            if mapExpendFlag && tableExpendFlag
            {
                self.tableViewHeightConstraint.constant = -20
                tableExpendFlag = false
                self.mapViewTopConstraint.constant = 20
                mapExpendFlag = false
            } else if mapExpendFlag && !tableExpendFlag {
                self.tableViewHeightConstraint.constant = -20
                tableExpendFlag = false
                self.mapViewTopConstraint.constant = 20
                mapExpendFlag = false
            }
            else {
                
                self.mapViewTopConstraint.constant = -(self.tableView.frame.size.height)
                mapExpendFlag = true
            }
        default:
            break
        }
        tableButtonImg.image = tableExpendFlag ? imgMin : imgMax
        mapButtonImg.image = mapExpendFlag ? imgMin : imgMax
        if date != nil
        {
            loadData(date)
        }
        
    }
    
    
}
extension SearchPreviousJobsViewController: UITableViewDataSource
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
    func getLinkByTitle(title: String) -> String
    {
        for i in 0 ..< jobs.count
        {
            if title == jobs[i].job_title
            {
                return jobs[i].job_link
            }
        }
        return ""
    }
    func subDaysFromNow(days: Int) -> String
    {
        let date = NSCalendar.currentCalendar().dateByAddingUnit( [.Day], value: days, toDate: NSDate(), options: [] )
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.stringFromDate(date!)
        return dateString
    }
}
extension SearchPreviousJobsViewController:UITableViewDelegate
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

extension SearchPreviousJobsViewController: GMSMapViewDelegate
{
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        let url = self.getLinkByTitle(marker.title!)
        if url != ""
        {
            if let link = NSURL(string: url)
            {
                UIApplication.sharedApplication().openURL(link)
            }
        }
    }
}
