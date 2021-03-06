//
//  SearchViewController.swift
//  yelp
//
//  Created by Kushagra Kumar Tiwary on 9/20/14.
//  Copyright (c) 2014 myorg. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var resultTableView: UITableView!
    
    @IBOutlet weak var searchNavigationItem: UINavigationItem!
    let ConsumerKey	= "1zNdMu4fossEqdlWzG8pWw"
    let ConsumerSecret = "uARbje0JuLYDoh7RrXwRHBf6LK4"
    let Token = "hE0crxcGsiFJrNPkaSp0FOHbK9hsBCKS"
    let TokenSecret = "lTXiwIyOc5Eq0YenH6s98xOa7m4"
    var resultDictionary :[NSDictionary]!
    
    var term = "Thai"
    var sort = 1
    var radiusFilter: Double = 10 * 1609.34
    var dealsFilter = false
    var categoryFilter = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        var searchBar = UISearchBar()
        self.navigationItem.titleView = searchBar
        searchBar.delegate = self

        searchItemWithFilters()
        
        resultTableView.dataSource = self
        resultTableView.delegate = self


    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func searchItemWithFilters() {
        let yelpClient = YelpClient(consumerKey: ConsumerKey, consumerSecret: ConsumerSecret, accessToken: Token, accessSecret: TokenSecret)
        yelpClient.searchWithFilters(term, sort: sort, radiusFilter: radiusFilter, dealsFilter: dealsFilter, categoryFilter: categoryFilter, success: {(request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
        self.populateSearchResult(request, response: response)}, failure: {(request: AFHTTPRequestOperation!, error: NSError!) -> Void in })
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println(searchBar.text)
        let yelpClient = YelpClient(consumerKey: ConsumerKey, consumerSecret: ConsumerSecret, accessToken: Token, accessSecret: TokenSecret)
        self.term = searchBar.text
        yelpClient.searchWithFilters(term, sort: sort, radiusFilter: radiusFilter, dealsFilter: dealsFilter, categoryFilter: categoryFilter, success: {(request: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            self.populateSearchResult(request, response: response)}, failure: {(request: AFHTTPRequestOperation!, error: NSError!) -> Void in })
//        searchItemWithFilters()
    }
    
    func populateSearchResult (request :AFHTTPRequestOperation!, response: AnyObject!) -> Void {
        let respDict = response as NSDictionary
        self.resultDictionary = respDict["businesses"] as [NSDictionary]
        self.resultTableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(resultDictionary == nil) {
            return -1
        } else {
            return resultDictionary.count;
        }
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultCell") as SearchResultTableViewCell
        let resultElements = self.resultDictionary[indexPath.item]
        cell.nameLabel.text = resultElements["name"] as? String
        let location = resultElements["location"] as NSDictionary
        let address = location["address"] as? NSArray
        cell.addressLabel.text = address?.objectAtIndex(0) as NSString
        let reviewsCount = resultElements["review_count"] as Int
        cell.reviewLabel.text = "\(reviewsCount) reviews"
        let category = resultElements["categories"] as NSArray
        let categoryInner = category.objectAtIndex(0) as NSArray
        var categoryStrings = ""
        for categoryObject in categoryInner  {
            categoryStrings += categoryObject as String
            categoryStrings += ","
        }
        cell.specialityLabel.text = categoryStrings
        let restaurantImageUrl = resultElements["image_url"] as String
        cell.restaurantImageView.setImageWithURL(NSURL(string: restaurantImageUrl))
        let ratingsImageUrl = resultElements["rating_img_url"] as String
        cell.reviewsImageVIew.setImageWithURL(NSURL(string: ratingsImageUrl))
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var filterView = segue.destinationViewController as FiltersViewController
        filterView.term = self.term
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
