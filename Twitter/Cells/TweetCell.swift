//
//  TweetCell.swift
//  Twitter
//
//  Created by Andy Celdo on 2/27/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
        
    // MARK: - @IBOutlet Variables and Global Vars
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var tweetTimeLabel: UILabel!
    
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var retweetBtn: UIButton!
    
    var favorited:Bool = false
    var tweetId:Int = -1
    
    // MARK: - @IBAction Functions
    
    @IBAction func favTweet(_ sender: Any) {
    
        let toBeFav = !favorited
        if(toBeFav) {
            TwitterAPICaller.client?.favTweet(tweetId: tweetId, success: {
                self.setFav(true)
            }, failure: { (Error) in
                print("favTweet @IBAction function if statement failed: \(Error)")
            })
        }
        else {
            TwitterAPICaller.client?.unFavTweet(tweetId: tweetId, success: {
                self.setFav(false)
            }, failure: { (Error) in
               print("favTweet @IBAction function else statement failed: \(Error)")
            })
        }
        
    }
    
    @IBAction func reTweet(_ sender: Any) {
    
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.setRetweeted(true)
        }, failure: { (Error) in
            print("reTweet @IBAction func failure called!: \(Error)")
        })
    
    }
    
    // MARK: - Override Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: - Other Functions
    
    func setFav(_ isFavorited:Bool) {
        favorited = isFavorited
        if(favorited) {
            favBtn.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            favBtn.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
    }
    
    func setRetweeted(_ isRetweeted:Bool) {
        
        if(isRetweeted) {
            retweetBtn.setImage(UIImage(named: "retweet-icon-green"), for:
                                    UIControl.State.normal)
            retweetBtn.isEnabled = false
        } else {
            retweetBtn.setImage(UIImage(named: "retweet-icon"), for:
                UIControl.State.normal)
            retweetBtn.isEnabled = true
        }
        
    }
    
}
