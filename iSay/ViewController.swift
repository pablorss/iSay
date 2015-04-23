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
        
        var permissionsArray : NSArray = [ "user_about_me", "user_relationships", "user_birthday", "user_location", "user_friends"];
        
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
                    FBRequestConnection.startForMeWithCompletionHandler({connection, result, error in
                        //var user = PFUser.currentUser()
                        var resultdict = result as NSDictionary
                        var id = resultdict.objectForKey("id") as String
                        var name = resultdict.objectForKey("name") as String
                        var user = PFUser()
                        user.setObject(name, forKey: "nombre")
                        user.setObject(id, forKey: "idFacebook")
                        var faceData = PFObject(className: "FacebookData")
                        faceData["nombre"] = name
                        faceData["idFacebook"] = id
                        faceData["usuario"] = PFUser.currentUser().username
                        user.saveInBackground()
                        faceData.saveInBackground()
                        //var timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
                        sleep(3)
                        self.performSegueWithIdentifier("login", sender: self)
                        //self.navigationController?.pushViewController(MenuPartidasViewController, animated: true)
                    })
                    //let defaults = NSUserDefaults.standardUserDefaults()
                    //defaults.setBool(true,forKey:"signedup")


                } else {
                    NSLog("User with facebook logged in!");
                    self.performSegueWithIdentifier("login", sender: self)
                    //self.navigationController?.pushViewController(MenuPartidasViewController, animated: true)

                }
            } })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /*if(PFUser.currentUser().isAuthenticated() && PFFacebookUtils.isLinkedWithUser(PFUser.currentUser())) {
            self.performSegueWithIdentifier("login", sender: self);
        }
        else {
        
        }*/
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

