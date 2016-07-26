//
//  FIltersViewController.swift
//  Yelp
//
//  Created by Kritarth Upadhyay on 7/25/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FIltersViewControllerDelegate {
    optional func filterViewController (filterViewController:FIltersViewController, didUpdateFilters filters:[String:AnyObject])
}


class FIltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var categories: [[String:String]]!
    var switchStates = [Int: Bool]()
    weak var delegate: FIltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
        self.categories = yelpCategories()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String:AnyObject]()
        
        var selectedCategories = [String]()
        for(row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if(selectedCategories.count>0) {
            filters["categories"] = selectedCategories
        }
        delegate?.filterViewController?(self, didUpdateFilters: filters)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func yelpCategories() -> [[String: String]] {
        return [["name":"Afgan", "code":"afgani"],
                ["name":"African", "code":"african"],
                ["name":"American, New", "code":"newamerican"],
                ["name":"Arabian", "code":"arabian"],
                ["name":"Asian Fusion", "code":"asianfusion"],
                ["name":"Australian", "code":"australian"],
                ["name":"Indian", "code":"indian"],
                ["name":"Barbeque", "code":"barbeque"],
                ["name":"Beer Garden", "code":"beergarden"]
                ]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        cell.SwitchLabel.text = self.categories[indexPath.row]["name"]
        cell.onSwitch.on = switchStates[indexPath.row] ?? false
        cell.delegate = self
        return cell
    }
    
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)
        switchStates[indexPath!.row] = value
    }

}
