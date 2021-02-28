//
//  LoginViewController.swift
//  Twitter
//
//  Created by Andy Celdo on 2/27/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func onLoginBtn(_ sender: Any) {
    
        let apiURL = "https://api.twitter.com/oauth/request_token"
        
        TwitterAPICaller.client?.login(url: apiURL, success: {
            
            UserDefaults.standard.setValue(true, forKey: "login")
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        
        }, failure: { (Error) in
            print("Couldn't login!")
        })
            
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "login") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
