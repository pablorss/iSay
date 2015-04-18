//
//  MenuPartidasViewController.swift
//  iSay
//
//  Created by Pablo Robles Sánchez on 3/15/15.
//  Copyright (c) 2015 Pablo Robles Sánchez. All rights reserved.
//

import UIKit

class MenuPartidasViewController: UITableViewController {
    

    
    var data : [NSDictionary] = []
    var partidasAmigos : [String] = []
    var nombresAmigos : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARCA ERROR CUANDO ES LA PRIMERA PRIMERA VEZ QUE HAGO LOGIN
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        var friendsRequest : FBRequest = FBRequest.requestForMyFriends()
        friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            var resultdict = result as NSDictionary
            //println("Result Dict: \(resultdict)")
            var data  = resultdict.objectForKey("data") as NSArray
            //println(data)
            var i = 0
            while (i < data.count) {
                let valueDict : NSDictionary = data[i] as NSDictionary
                let name = valueDict.objectForKey("name") as NSString
                let id = valueDict.objectForKey("id") as NSString
                self.partidasAmigos.append(id)
                self.nombresAmigos.append(name)
                i++
            }
            //println(self.partidasAmigos)
            self.tableView.reloadData()
        }
        //self.llenarTabla()
        
    }
    
    func llenarTabla(){
        var user = PFQuery(className: "FacebookData")
        user.whereKey("usuario", equalTo: PFUser.currentUser().username)
        let r = user.findObjects()
        var id = r[0].objectForKey("idFacebook") as String
        println("El id es: %", &id)
        var query = PFQuery(className: "Registro")
        query.whereKey("username", equalTo: id)
        let r2 = query.findObjects()
        println(r2)
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
