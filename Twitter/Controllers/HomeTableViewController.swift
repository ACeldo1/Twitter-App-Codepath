//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Andy Celdo on 2/27/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    // MARK: - Data Members/Variables

    var tweetArr = [NSDictionary]()
    var numOfTweets: Int!
    let myRefreshControl = UIRefreshControl()
    
    // MARK: - @IBAction Functions
    
    @IBAction func onLogout(_ sender: Any) {
        
        UserDefaults.standard.setValue(false, forKey: "login")
        
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true) {
            print("dismiss called!")
        }
    }
    
    // MARK: - Override Functions
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let user = tweetArr[indexPath.row]["user"] as! NSDictionary
        let content = tweetArr[indexPath.row]["text"] as! String
        let time = tweetArr[indexPath.row]["created_at"] as! String
        
        let imageURL = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageURL!)

        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.usernameLabel.text = user["name"] as? String
        cell.tweetContentLabel.text = content
        
        let endOfTimeStr = time.firstIndex(of: "+")     
        let formattedTime = String(time[...endOfTimeStr!].dropLast())
        cell.tweetTimeLabel.text = formattedTime
        
        cell.setFav(tweetArr[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArr[indexPath.row]["id"] as! Int
        cell.setRetweeted(tweetArr[indexPath.row]["retweeted"] as! Bool)

        print(time)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged )
        tableView.refreshControl = myRefreshControl
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 176
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArr.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArr.count {
            loadMoreTweets()
        }
    }

    // MARK: - Other Functions
    
    @objc func loadTweets() {
        
        numOfTweets = 20
        
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numOfTweets] //can add other parameters according to Twitter API docs
        
        //needed self for tweetArr because this is all considered a closure
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArr.removeAll() //have a nice, empty array
            for tweet in tweets {
                self.tweetArr.append(tweet)
            }
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets")
        })
        
    }
    
    func loadMoreTweets() {
        
        numOfTweets += 20
        
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numOfTweets] //can add other parameters according to Twitter API docs
        
        //needed self for tweetArr because this is all considered a closure
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams, success: {
            (tweets: [NSDictionary]) in
            
            self.tweetArr.removeAll() //have a nice, empty array
            for tweet in tweets {
                self.tweetArr.append(tweet)
            }
            
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets")
        })
        
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
