//
//  SeleccionarAmigoView.swift
//  iSay
//
//  Created by Pablo Robles Sánchez on 3/15/15.
//  Copyright (c) 2015 Pablo Robles Sánchez. All rights reserved.
//

import UIKit

class SeleccionarAmigoView: UITableViewController {
    //var friends : NSDictionary!
    //var registros : Int!
    var names : [String] = []
    var ids : [String] = []
    var name : String = ""
    var id : String = ""
    var estaEncontrada : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //JALA LOS AMIGOS DE FACEBOOK PARA INVITAR A JUGAR
        facebookFriends()
    }
    
    /*func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) -> Void
    {
        FBRequestConnection.startForMeWithCompletionHandler({connection, result, error in
            if (!error)
            {
                PFUser.currentUser().setObject(result.id as? String, forKey: "fbId")
                PFUser.currentUser().saveInBackground()
            }
            else
            {
                println("Error")
            }
        })
    }*/

    func facebookFriends() {
        var friendsRequest : FBRequest = FBRequest.requestForMyFriends()
        friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            var resultdict = result as! NSDictionary
            var data  = resultdict.objectForKey("data") as! NSArray
            var i = 0
            while (i < data.count) {
                let valueDict : NSDictionary = data[i] as! NSDictionary
                let id = valueDict.objectForKey("id")as! NSString
                let name = valueDict.objectForKey("name") as! NSString
                
                //Checar si los usuarios no tienen una partida con el jugador
                
                self.names.append(name as String)
                self.ids.append(id as String)
                i++
            }
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //return self.friends!.count
        return self.names.count
    }

  
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = self.names[indexPath.row]
        return cell
    }
    
    func llenafalso() {
        self.estaEncontrada = false
        println("llene falso")
    }
    
    func checarPartida (p1: NSString, row: NSInteger) -> Void {
        self.estaEncontrada = true
        var busca = PFQuery(className: "Registro")
        busca.whereKey("username", equalTo: p1)
        busca.whereKey("contrincante", equalTo: self.ids[row])
        let r1 = busca.findObjects()
        if r1.count > 0{
            self.llenafalso()
        }
        busca = PFQuery(className: "Registro")
        busca.whereKey("username", equalTo: self.ids[row])
        busca.whereKey("Contrincante", equalTo: p1)
        let r2 = busca.findObjects()
        if r2.count > 0{
            self.llenafalso()
        }

        
        println("saliendo del metodo")
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var query = PFObject(className: "Partidas")
        var idplayer1 : String = ""
        var user = PFUser.currentUser()
        var userInfo = PFQuery(className:"FacebookData")
        userInfo.whereKey("usuario", equalTo: user.username)
        let result : NSArray = userInfo.findObjects()
        for object in result {
            idplayer1 = object.objectForKey("idFacebook") as! NSString as String
            self.id = self.ids[indexPath.row]
        }
        self.checarPartida(idplayer1 as NSString, row: indexPath.row as NSInteger)
        if(self.estaEncontrada){
            var partida = PFObject(className: "Partidas")
            partida["estaActiva"] = false
            partida["primeraVez"] = true
            partida["turno"] = idplayer1
            partida["movimientos"] = 4
            partida["partida"] = []
            partida.save()

            println(partida.objectId)
            var jugada1 = PFObject(className: "Registro")
            jugada1["username"] = idplayer1
            jugada1["contrincante"] = self.id
            jugada1["partida"] = partida.objectId
            println("JUGADA1")
            var jugada2 = PFObject(className: "Registro")
            jugada2["username"] = self.id
            jugada2["contrincante"] = idplayer1
            jugada2["partida"] = partida.objectId
            println("JUGADA2")
            jugada1.saveInBackground()
            jugada2.saveInBackground()
            //println("Ya me voy")
        }
         self.navigationController?.popToRootViewControllerAnimated(true)
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
