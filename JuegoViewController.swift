//
//  JuegoViewController.swift
//  iSay
//
//  Created by Pablo Robles Sánchez on 4/10/15.
//  Copyright (c) 2015 Pablo Robles Sánchez. All rights reserved.
//

import UIKit

class JuegoViewController: UIViewController {

    @IBOutlet weak var botonRojo: UIButton!
    @IBOutlet weak var botonVerde: UIButton!
    @IBOutlet weak var botonAzul: UIButton!
    @IBOutlet weak var botonAmarillo: UIButton!
    
    @IBAction func solteRojo(sender: AnyObject) {
        self.botonRojo.backgroundColor = UIColor.redColor()
    }
    
    @IBAction func solteVerde(sender: AnyObject) {
        self.botonVerde.backgroundColor = UIColor.greenColor()
    }
    
    @IBAction func solteAzul(sender: AnyObject) {
        self.botonAzul.backgroundColor = UIColor.blueColor()
    }
    
    @IBAction func solteAmarillo(sender: AnyObject) {
        self.botonAmarillo.backgroundColor = UIColor.yellowColor()
    }
    
    @IBAction func oprimiRojo(sender: AnyObject) {
        self.botonRojo.backgroundColor = UIColor.whiteColor()
    }
    
    @IBAction func oprimiVerde(sender: AnyObject) {
        self.botonVerde.backgroundColor = UIColor.whiteColor()
    }
    
    @IBAction func oprimiAzul(sender: AnyObject) {
        self.botonAzul.backgroundColor = UIColor.whiteColor()
    }
    
    @IBAction func oprimiAmarillo(sender: AnyObject) {
        self.botonAmarillo.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.botonRojo.backgroundColor = UIColor.redColor()
        self.botonVerde.backgroundColor = UIColor.greenColor()
        self.botonAzul.backgroundColor = UIColor.blueColor()
        self.botonAmarillo.backgroundColor = UIColor.yellowColor()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
