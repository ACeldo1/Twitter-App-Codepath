//
//  TweetCell.swift
//  Twitter
//
//  Created by Andy Celdo on 2/27/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
        
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
