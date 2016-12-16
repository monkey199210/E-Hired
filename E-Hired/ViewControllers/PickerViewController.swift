//
//  PickerViewController.swift
//  E-Hired
//
//  Created by Rui Caneira on 9/20/16.
//  Copyright © 2016 Rui Caneira. All rights reserved.
//

import UIKit
class PickerViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    let industry = ["Accounting / Finance", "Admin / Office", "Architecture / Engineering", "Art / Media / Design", "Biotech / Science", "Business / Management"]
    let availability = ["Full Time", "Open", "Part Time", "Seasonal", "Temporary"]
    let salary = ["$ 100000 - 125000", "$ 125000 - 150000", "$ 25000 - 50000", "$ 50000 - 75000", "$ 75000 - 100000", "Negotiable"]
    let education = ["Associates Degree", "Bachelors Degree", "Certification", "Doctorate","High School", "Masters"]
    var data:[String] = []
    var index = 0
    var selectedItem = ""
    var profileVC: YourProfileViewController!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
    
        switch index {
        case 0:
            data = industry
            self.titleLabel.text = "Industry"
        case 1:
            data = availability
            self.titleLabel.text = "Availability"
        case 2:
            data = salary
            self.titleLabel.text = "Salary"
        default:
            data = education
            self.titleLabel.text = "Education"
        }
    }
    override func didReceiveMemoryWarning() {
        
    }
}
extension PickerViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = data[indexPath.row]
        if data[indexPath.row] == selectedItem
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        return cell
    }
}
extension PickerViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        profileVC.changeInfo(index, str: data[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
}
