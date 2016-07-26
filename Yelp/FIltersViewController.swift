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

    struct Objects {
        var sectionName: String!
        var sectionObjects: [[String:String]]!
    }
    
    @IBOutlet weak var tableView: UITableView!
    var switchStates = [[Int: Bool]]()
    
    var categories: [[String:String]]!
    var sort: [[String:String]]!
    var deals : [[String:String]]!
    weak var delegate: FIltersViewControllerDelegate?
    var filterArray = [Objects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
        self.categories = yelpCategories()
        self.sort = sorts()
        self.deals = dealsCode()
        
        //setup all label data together in single array
        self.filterArray = [Objects(sectionName: "Sort", sectionObjects: self.sort),
                            Objects(sectionName: "deals", sectionObjects: self.deals),
                            Objects(sectionName: "Categories", sectionObjects: self.categories)]
        switchStates.append([Int:Bool]())
        switchStates.append([Int:Bool]())
        switchStates.append([Int:Bool]())

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
        filters["deals"] = false
        filters["sort"] = 0
        
        var selectedCategories = [String]()
        for(row, isSelected) in switchStates[2] {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        if(selectedCategories.count>0) {
            filters["categories"] = selectedCategories
        }
        
        for(row, isSelected) in switchStates[0] {
            if isSelected {
                filters["sort"] = Int(self.sort[row]["code"]!)
            } else {
                filters["sort"] = 0
            }
        }
        
        for(_, isSelected) in switchStates[1] {
            if isSelected {
                filters["deals"] = true
            } else {
                filters["deals"] = false
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
    
    func dealsCode() -> [[String:String]] {
        return [["name" : "Yelp Deals", "code": "true"]]
    }
    
    func sorts() -> [[String:String]] {
        return [["name" : "Best Match", "code": "0"], ["name" : "Best Rating", "code": "2"], ["name" : "Distance", "code": "1"]]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterArray[section].sectionObjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        cell.SwitchLabel.text = self.filterArray[indexPath.section].sectionObjects[indexPath.row]["name"]
        cell.onSwitch.on = switchStates[indexPath.section][indexPath.row] ?? false
        cell.delegate = self
        return cell
    }
    
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)
        /**
        if(indexPath?.section != 2 && value) {
            for var i = 0; i < (switchStates[(indexPath?.section)!].count); i++ {
                switchStates[(indexPath?.section)!][i] = false
            }
        }
         */
        switchStates[(indexPath?.section)!][indexPath!.row] = value
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.filterArray.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.filterArray[section].sectionName
    }

}
