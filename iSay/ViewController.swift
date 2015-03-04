//
//  ViewController.swift
//  iSay
//
//  Created by Pablo Robles Sánchez on 03/03/15.
//  Copyright (c) 2015 Pablo Robles Sánchez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func facebookLogin(sender: AnyObject) {
        
        var permissionsArray : NSArray = [ "user_about_me", "user_relationships", "user_birthday", "user_location"];
        
        // Login PFUser using Facebook
        var login = PFFacebookUtils.logInWithPermissions(permissionsArray, block: { (user : PFUser!, error : NSError!) -> Void in
            if(user == nil){
                var errorMessage : String?
                if (error == nil){
                    NSLog("Uh oh. The user cancelled the Facebook login.");
                    errorMessage = "Uh oh. The user cancelled the Facebook login.";
                } else {
                    NSLog("Uh oh. An error occurred: %@", error);
                    errorMessage = error.localizedDescription //[error localizedDescription];
                }
                var alert = UIAlertController(title: "Error al iniciar sesión", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

            } else {
                if (user.isNew) {
                    NSLog("User with facebook signed up and logged in!");
                    //[self performSegueWithIdentifier: "login" sender: self];
                    self.performSegueWithIdentifier("login", sender: self)
                } else {
                    NSLog("User with facebook logged in!");
                    //[self performSegueWithIdentifier: "login" sender: self];
                    self.performSegueWithIdentifier("login", sender: self)
                }
            } })
        

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

