//
//  MenuPartidasViewController.swift
//  iSay
//
//  Created by Pablo Robles Sánchez on 3/15/15.
//  Copyright (c) 2015 Pablo Robles Sánchez. All rights reserved.
//

import UIKit

class MenuPartidasViewController: UITableViewController {
    

    //var username = ""
    var data : [NSDictionary] = []
    var partidasAmigos : [String] = []
    var nombresAmigos : [String] = []
    var idMio : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.nombresAmigos = []
        self.partidasAmigos = []
        //self.llenarTabla()
        self.llenarTabla()
        //self.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController!.navigationBar.barTintColor = UIColor(red: 26/255, green: 188/255, blue: 156/255, alpha: 1)
    }
    
    func llenarTabla(){
        var user = PFQuery(className: "FacebookData")
        user.whereKey("usuario", equalTo: PFUser.currentUser().username)
        let r = user.findObjects()
        self.idMio = r[0].objectForKey("idFacebook") as! String
        var query = PFQuery(className: "Registro")
        query.whereKey("username", equalTo: self.idMio)
        let r2 = query.findObjects()
        println(r2)
        for object in r2 {
            var contrincante = object["contrincante"] as! String
            var search = PFQuery(className: "FacebookData")
            search.whereKey("idFacebook", equalTo: contrincante)
            let result = search.findObjects()
            self.nombresAmigos.append(result[0].objectForKey("nombre") as! String)
            self.partidasAmigos.append(contrincante)
            self.tableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        //llenarPartidas()
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.nombresAmigos.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        cell.textLabel?.text = self.nombresAmigos[indexPath.row]
        
        return cell
    }
    
     override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //self.navigationController?.pushViewController(<#viewController: UIViewController#>, animated: <#Bool#>)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        if segue.identifier == "juego" {
            let detalleJuego = segue.destinationViewController as! JuegoViewController
            let indiceActual = self.tableView.indexPathForSelectedRow()
            let row = indiceActual?.row
            let idContrincante = self.partidasAmigos[row!]
            detalleJuego.idMio = self.idMio
            detalleJuego.idContrincante = idContrincante
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        PFUser.logOut()
        var currentUser = PFUser.currentUser()
        if currentUser == nil {}
        self.performSegueWithIdentifier("logout", sender: self)
        
    }
    
}
