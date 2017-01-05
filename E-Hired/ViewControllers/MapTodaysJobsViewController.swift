//
//  TodayJobsViewController.swift
//  E-Hired
//
//  Created by Rui Caneira on 9/18/16.
//  Copyright © 2016 Rui Caneira. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
class MapTodaysJobsViewController: UIViewController {
    
    let TODAY_JOB_BTN = 1
    let MAIN_PAGE_BTN = 2
    let TABLE_EXPEND_BTN = 3
    let MAP_EXTEND_BTN = 4
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    var mapExpendFlag = false
    var tableExpendFlag = false
    @IBOutlet weak var mapButtonImg: UIImageView!
    @IBOutlet weak var tableButtonImg: UIImageView!
    @IBOutlet var buttons: [UIButton]!
    
    //job information
    @IBOutlet weak var loadingView: activityIndicator!
    var jobs:[EHJobs.Detail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GoogleAnalitics.send(GoogleAnalitics.MapTodayJobScreen.ScreenName)
        initView()
        initData()
    }
    
    func initView()
    {
        self.loadingView.hidesWhenCompleted = true
        tableView.registerNib(JobCell.cellNib, forCellReuseIdentifier: JobCell.id)
        for i in 0 ..< buttons.count
        {
            buttons[i].layer.cornerRadius = 8
        }
        self.mapView.delegate = self
    }
    func initData()
    {
        self.jobs = []
        self.loadingView.hidden = false
        self.loadingView.startLoading()
        Net.getJobs(nil).onSuccess(callback: {(jobList) -> Void in
            let status = jobList.status
            if status == "ok"
            {
                self.jobs = jobList.detail
                if self.jobs.count != 0 {
                    self.requestJobViewed()
                }

                self.setupPins()
            }
            self.tableView.reloadData()
            self.loadingView.completeLoading(true)
            self.loadingView.hidden = true
        }).onFailure(callback: { (_) -> Void in
            self.loadingView.completeLoading(true)
            self.loadingView.hidden = true
            self.tableView.reloadData()
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
    
    func setuplocationMarker(coordinate: CLLocationCoordinate2D, index:Int) {
        let maker = GMSMarker(position: coordinate)
        maker.title = jobs[index].job_company
        maker.snippet = jobs[index].job_site
        maker.map = mapView
        maker.appearAnimation = kGMSMarkerAnimationPop
        maker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        maker.flat = true

    }
    @IBAction func action(sender: UIButton) {
        let imgMin = UIImage(named: "reduceBtnMin")
        let imgMax = UIImage(named: "reduceBtnMax")
        switch sender.tag {
            
        case TODAY_JOB_BTN:
            GoogleAnalitics.send(GoogleAnalitics.MapTodayJobScreen.ScreenName, category: GoogleAnalitics.MapTodayJobScreen.Category, action: GoogleAnalitics.MapTodayJobScreen.Action, label: GoogleAnalitics.MapTodayJobScreen.TODAYJOBBUTTON)
            let todayJobVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TodayJobsViewController") as! TodayJobsViewController
            self.navigationController?.pushViewController(todayJobVC, animated: true)
        case MAIN_PAGE_BTN:
            GoogleAnalitics.send(GoogleAnalitics.MapTodayJobScreen.ScreenName, category: GoogleAnalitics.MapTodayJobScreen.Category, action: GoogleAnalitics.MapTodayJobScreen.Action, label: GoogleAnalitics.MapTodayJobScreen.MAINPAGEBUTTON)
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
extension MapTodaysJobsViewController: UITableViewDataSource
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
            if title == jobs[i].job_company
            {
                return jobs[i].job_link
            }
        }
        return ""
    }
}
extension MapTodaysJobsViewController:UITableViewDelegate
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

extension MapTodaysJobsViewController: GMSMapViewDelegate
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
//class PlaceMarker: GMSMarker {
//    // 1
//    let place: GooglePlace
//    
//    // 2
//    init(place: GooglePlace) {
//        self.place = place
//        super.init()
//        
//        position = place.coordinate
//        icon = UIImage(named: place.placeType+"_pin")
//        groundAnchor = CGPoint(x: 0.5, y: 1)
//        appearAnimation = kGMSMarkerAnimationPop
//    }
//}