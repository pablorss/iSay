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
            var resultdict = result as NSDictionary
            //println("Result Dict: \(resultdict)")
            var data  = resultdict.objectForKey("data") as NSArray
            //println(data)
            var i = 0
            while (i < data.count) {
                let valueDict : NSDictionary = data[i] as NSDictionary
                let id = valueDict.objectForKey("id") as NSString
                let name = valueDict.objectForKey("name") as NSString
                
                //Checar si los usuarios no tienen una partida con el jugador
                
                self.names.append(name)
                self.ids.append(id)
                //println(data[i])
                //Editar información de la lista
                //println("the id value is \(id)")
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
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

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
        var busca = PFQuery(className: "Partidas")
        busca.whereKey("player1", equalTo: p1)
        busca.whereKey("player2", equalTo: self.ids[row])
        let r1 = busca.findObjects()
        if r1.count > 0{
            self.llenafalso()
        }
        busca = PFQuery(className: "Partidas")
        busca.whereKey("player1", equalTo: self.ids[row])
        busca.whereKey("player2", equalTo: p1)
        let r2 = busca.findObjects()
        if r2.count > 0{
            self.llenafalso()
        }

        
        println("saliendo del metodo")
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var query = PFObject(className: "Partidas")
        var idplayer1 : String = ""
        //var idplayer2 : String = ""
        var user = PFUser.currentUser()
        var userInfo = PFQuery(className:"FacebookData")
        userInfo.whereKey("usuario", equalTo: user.username)
        let result : NSArray = userInfo.findObjects()
        for object in result {
            //println(object.objectForKey("nombre") as NSString)
            idplayer1 = object.objectForKey("idFacebook") as NSString
            self.id = self.ids[indexPath.row]
        }
        self.checarPartida(idplayer1 as NSString, row: indexPath.row as NSInteger)
        if(self.estaEncontrada){
            var partida = PFObject(className: "Partidas")
            partida["player1"] = idplayer1 as NSString
            partida["player2"] = self.id as NSString
            partida["estaActiva"] = false
            println(partida)
            println(partida.objectId)
            partida.save()
            //partida.saveInBackground()
            
            //var q = PFQuery(className: "")
            println(partida.objectId)
            var jugada1 = PFObject(className: "Registro")
            jugada1["username"] = idplayer1
            jugada1["partida"] = partida.objectId
            println("JUGADA1")
            var jugada2 = PFObject(className: "Registro")
            jugada2["username"] = self.id
            jugada2["partida"] = partida.objectId
            println("JUGADA1")
            jugada1.saveInBackground()
            jugada2.saveInBackground()
            println("Ya me voy")
        }
        //println(result[0]["nombre"])
        //var aux = result[0]
        //println(aux["nombre"])
        
        //println(result["nombre"])
        /*userInfo.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if error == nil {
                // The find succeeded.
                //NSLog("Successfully retrieved \(objects.count) scores.")
                //NSLog("%@", objects)
                // Do something with the found objects
                for object in objects {
                    // Hacer el query para insertar la info
                    //self.funlists.append(object.name)
                    idplayer1 = object["idFacebook"] as NSString
                    //println(idplayer1)
                    self.id = self.ids[indexPath.row]
                    self.checarPartida(idplayer1 as NSString, row: indexPath.row as NSInteger)
                        println(self.estaEncontrada)
                        if(self.estaEncontrada){
                            var partida = PFObject(className: "Partidas")
                            partida["player1"] = idplayer1 as NSString
                            partida["player2"] = self.id as NSString
                            partida["estaActiva"] = false
                            println(partida)
                            partida.saveInBackground()
                            var jugada1 = PFObject(className: "Registro")
                            jugada1["username"] = idplayer1
                            jugada1["partida"] = partida.objectId
                            var jugada2 = PFObject(className: "Registro")
                            jugada2["username"] = self.id
                            jugada2["partida"] = partida.objectId
                            jugada1.saveInBackground()
                            jugada2.saveInBackground()
                            println("Ya me voy")
                        }

                    
                   
                }
                
                    
                
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }*/
        
        /*userInfo.getObjectInBackgroundWithId(user.username) {
            (gameScore: PFObject!, error: NSError!) -> Void in
            if error == nil && gameScore != nil {
                println(gameScore)
            } else {
                println(error)
            }
        }*/
        //self.name = self.names[indexPath.row]
        //self.id = self.ids[indexPath.row]
        //query.setObject(self.id, forKey: "player1")
        //query.setObject(user., forKey: String!)
        println("Ya me voy")
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
