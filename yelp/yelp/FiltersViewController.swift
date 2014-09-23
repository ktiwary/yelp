//
//  FiltersViewController.swift
//  yelp
//
//  Created by Kushagra Kumar Tiwary on 9/21/14.
//  Copyright (c) 2014 myorg. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var term = ""
    var isSelected = [Int: Bool] ()
    let sectionHt = [0:10, 1:40, 2:10, 3:10, 4:30]
    let sectionRows = [0:1, 1:4, 2:4, 3:4, 4:4]
    let sectionLabel = [0:"Price", 1:"Most Popular", 2:"Distance", 3:"Sort by", 4:"Category"]
    let sectionCells = [0:"PriceCell", 1:"DealsCell", 2:"RadiusCell", 3:"SortCell", 4:"CategoryCell"]
    let dealsCells = [0:"Open Now", 1:"Hot & New", 2:"Offering a Deal", 3:"Delivery"]
    
    let categoryCells = [0:"Restaurants", 1:"Bars", 2:"Coffee & Tea", 3:"More Categories"]
    
    let moreCategoryCells = [0:"Restaurants", 1:"Bars", 2:"Coffee & Tea", 3:"Hot & New", 4:"Gas Services", 5:"Shopping", 6:"Delivery", 7:"Drugstores"]
    
    var isShowMoreCategories = false
    
    let distanceLabel = [0:"0.3 miles", 1:"1 mile", 2:"5 miles", 3:"20 miles"]
    var distanceRowSelected = 0
    
    var dealsValueSelected = false
    
    let sortLabel = [0:"Best Match", 1:"Distance", 2:"Rating", 3:"Most Reviewed"]
    var sortRowSelected = 0

    @IBOutlet weak var filterTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTable.dataSource = self
        filterTable.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = self.sectionCells[indexPath.section]!
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("PriceCell") as PriceCell
            return cell
        } else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCellWithIdentifier("DealsCell") as DealsCell
            cell.dealsLabel.text = dealsCells[indexPath.row]
            return cell
        } else if (indexPath.section == 2) {
            let cell = tableView.dequeueReusableCellWithIdentifier("RadiusCell") as RadiusCell
            if(isSelected[indexPath.section] == nil || !isSelected[indexPath.section]!) {
                cell.radiusLabel.text = distanceLabel[distanceRowSelected]
            } else {
                cell.radiusLabel.text = distanceLabel[indexPath.row]
                if(indexPath.row == distanceRowSelected) {
                    cell.backgroundColor = UIColor.brownColor()
                } else {
                    cell.backgroundColor = UIColor.lightTextColor()
                }
            }
            return cell
        } else if (indexPath.section == 3) {
            let cell = tableView.dequeueReusableCellWithIdentifier("SortCell") as SortCell
            if(isSelected[indexPath.section] == nil || !isSelected[indexPath.section]!) {
                cell.sortLabel.text = sortLabel[sortRowSelected]
            } else {
                cell.sortLabel.text = sortLabel[indexPath.row]
                if(indexPath.row == sortRowSelected) {
                    cell.backgroundColor = UIColor.brownColor()
                } else {
                    cell.backgroundColor = UIColor.lightTextColor()
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as CategoryCell
            if isShowMoreCategories {
                cell.categoryLabel.text = moreCategoryCells[indexPath.row]
                cell.categorySwitch.alpha = 1
            } else {
                cell.categoryLabel.text = categoryCells[indexPath.row]
                if(indexPath.row == 3) {
                    cell.categorySwitch.alpha = 0
                }
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 2 || section == 3) {
            if(isSelected[section] == nil || !isSelected[section]!) {
                return 1
            }
        }
        if section == 4 {
            if isShowMoreCategories {
                return moreCategoryCells.count
            } else {
                return categoryCells.count
            }
        }
        return sectionRows[section]!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let height = sectionHt[section] as Int!
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 30))
        headerView.backgroundColor = UIColor.lightGrayColor()
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 300, height: 20))
        label.text = sectionLabel[section]
        label.font = UIFont.systemFontOfSize(10)
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 || indexPath.section == 3 {
            if(isSelected[indexPath.section] == nil || !isSelected[indexPath.section]!) {
                isSelected[indexPath.section] = true
            } else {
                isSelected[indexPath.section] = false
                if(indexPath.section == 2) {
                    distanceRowSelected = indexPath.row
                } else if(indexPath.section == 3) {
                    sortRowSelected = indexPath.row
                }
            }
        } else if indexPath.section == 4 {
            isShowMoreCategories = true
        } else if indexPath.section == 1 && indexPath.row == 2 {
            dealsValueSelected = !dealsValueSelected
        }
        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(sender.isKindOfClass(UIBarButtonItem)) {
            let button = sender! as UIBarButtonItem
            if "Search" == button.title! {
                let searchView = segue.destinationViewController as SearchViewController
                searchView.sort = sortRowSelected
                var radisFilter: Double = 0;
                if distanceRowSelected == 0 {
                    radisFilter = 0.3 * 1609.34
                } else if distanceRowSelected == 1 {
                    radisFilter = 1609.34
                } else if distanceRowSelected == 2 {
                    radisFilter = 5 * 1609.34
                } else if distanceRowSelected == 3 {
                    radisFilter = 20 * 1609.34
                }
                searchView.radiusFilter = radisFilter
                println(dealsValueSelected)
                searchView.dealsFilter = dealsValueSelected
                searchView.term = self.term
            }
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
