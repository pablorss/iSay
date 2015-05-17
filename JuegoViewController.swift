
//
//  JuegoViewController.swift
//  iSay
//
//  Created by Pablo Robles Sánchez on 4/10/15.
//  Copyright (c) 2015 Pablo Robles Sánchez. All rights reserved.
//

import UIKit

class JuegoViewController: UIViewController {
    var idContrincante : String = ""
    var idMio : String = ""
    var partida : NSString = ""
    var turno : String = ""
    var estaActiva : Bool = true
    var primeraVez : Bool = true
    var movimientos : Int = 0
    var limiteMovimientos : Int = 0
    var juegoArray : [String] = []
    var juegoLocal : [String] = []
    var timer = NSTimer()
    var contTimer : Int = 0
    

    @IBOutlet weak var botonRojo: UIButton!
    @IBOutlet weak var botonVerde: UIButton!
    @IBOutlet weak var botonAzul: UIButton!
    @IBOutlet weak var botonAmarillo: UIButton!
    
    @IBAction func solteRojo(sender: AnyObject) {
        self.botonRojo.backgroundColor = UIColor.redColor()
        if !self.primeraVez{
            self.validaArreglo()
        }
    }
    
    @IBAction func solteVerde(sender: AnyObject) {
        self.botonVerde.backgroundColor = UIColor.greenColor()
        if !self.primeraVez{
            self.validaArreglo()
        }
    }
    
    @IBAction func solteAzul(sender: AnyObject) {
        self.botonAzul.backgroundColor = UIColor.blueColor()
        if !self.primeraVez{
            self.validaArreglo()
        }
    }
    
    @IBAction func solteAmarillo(sender: AnyObject) {
        self.botonAmarillo.backgroundColor = UIColor.yellowColor()
        if !self.primeraVez{
            self.validaArreglo()
        }
    }
    
    @IBAction func oprimiRojo(sender: AnyObject) {
        self.botonRojo.backgroundColor = UIColor.whiteColor()
        self.juegoLocal.append("rojo")
        if self.primeraVez{
            self.iniciaJugada()
        }
    }
    
    @IBAction func oprimiVerde(sender: AnyObject) {
        self.botonVerde.backgroundColor = UIColor.whiteColor()
        self.juegoLocal.append("verde")
        if self.primeraVez{
            self.iniciaJugada()
        }
    }
    
    @IBAction func oprimiAzul(sender: AnyObject) {
        self.botonAzul.backgroundColor = UIColor.whiteColor()
        self.juegoLocal.append("azul")
        if self.primeraVez{
            self.iniciaJugada()
        }
    }
    
    @IBAction func oprimiAmarillo(sender: AnyObject) {
        self.botonAmarillo.backgroundColor = UIColor.whiteColor()
        self.juegoLocal.append("amarillo")
        if self.primeraVez{
            self.iniciaJugada()
        }
    }
    
    func validaArreglo(){
        if self.movimientos < self.limiteMovimientos {
            //El juego sigue
            if self.juegoLocal[self.movimientos] == self.juegoArray[self.movimientos] {
                self.movimientos++
            }
            else {
                var obj = PFObject(withoutDataWithClassName: "Partidas", objectId: self.partida as String)
                obj["primeraVez"] = true
                obj["movimientos"] = 3
                obj.saveInBackground()
                var query = PFQuery(className: "FacebookData")
                query.whereKey("idFacebook", equalTo: self.idContrincante)
                let result = query.findObjects()
                var obId = result[0].objectForKey("objectId") as! String
                var ganadas = result[0].objectForKey("ganadas") as! Int
                var obj2 = PFObject(withoutDataWithClassName: "FacebookData", objectId: obId)
                obj2["ganadas"] = ganadas + 1
                obj2.saveInBackground()
                var alert = UIAlertController(title: "Has perdido", message: "Si quieres volver a jugar selecciona a tu adversario", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
                //segue to menu
                self.performSegueWithIdentifier("ToMenu", sender:self)
            }
        }
        else {
            //El juego ha terminado
            var obj = PFObject(withoutDataWithClassName: "Partidas", objectId: self.partida as String)
            obj["partida"] = self.juegoLocal
            obj["primeraVez"] = false
            obj["turno"] = self.idContrincante
            obj["movimientos"] = self.juegoLocal.count
            //var query = PFQuery(className: "Partidas")
            //query.whereKey("objectId", equalTo: self.partida)
            //let result = query.findObjects()
            obj.saveInBackground()
            //println(self.juegoLocal)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func iniciaJugada(){
        self.movimientos++
        if self.movimientos > self.limiteMovimientos {
            var obj = PFObject(withoutDataWithClassName: "Partidas", objectId: self.partida as String)
            obj["partida"] = self.juegoLocal
            obj["primeraVez"] = false
            obj["turno"] = self.idContrincante
            obj["estaActiva"] = true
            obj["movimientos"] = self.juegoLocal.count
            //var query = PFQuery(className: "Partidas")
            //query.whereKey("objectId", equalTo: self.partida)
            //let result = query.findObjects()
            obj.saveInBackground()
            //println(self.juegoLocal)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.botonRojo.backgroundColor = UIColor.redColor()
        self.botonVerde.backgroundColor = UIColor.greenColor()
        self.botonAzul.backgroundColor = UIColor.blueColor()
        self.botonAmarillo.backgroundColor = UIColor.yellowColor()
        self.buscarPartida()
        var query = PFQuery(className: "Partidas")
        //query.whereKeyExists(self.partida)
        query.whereKey("objectId", equalTo: self.partida)
        //query.getObjectWithId(self.partida)
        let jugada = query.findObjects()
        self.estaActiva = jugada[0].objectForKey("estaActiva") as! Bool
        self.limiteMovimientos = jugada[0].objectForKey("movimientos") as! Int
        println(self.limiteMovimientos)
        self.turno = jugada[0].objectForKey("turno") as! String
        self.primeraVez = jugada[0].objectForKey("primeraVez") as! Bool
        println(self.primeraVez)
        self.juegoArray = jugada[0].objectForKey("partida") as! [String]
        
        if !self.primeraVez{
            
            if self.turno != self.idMio {
                //NO ES MI TURNO
                var alert = UIAlertController(title: "No es tu turno", message: "Espera a que tu contrincante responda el juego", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            
        }
        else{
            //SI ES MI TURNO
        }
        /*if !self.primeraVez {
            self.juegoArray = jugada[0].objectForKey("partida") as [String]
        }*/
        //println(jugada)
        
        // Do any additional setup after loading the view.
    }
    /*
    override func viewDidAppear(animated: Bool) {
        //println(self.estaActiva)
        if self.estaActiva {
            //EL JUEGO SE ESTA LLEVANDO A CABO
            //RECREAR LA JUGADA
            //self.recrearJugada()
            //println("recrearJugada")
            //println(self.juegoArray)
        }

    }*/
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        println(self.juegoArray)
        println(self.limiteMovimientos)
        if !self.primeraVez{
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: ("mostrarCadena"), userInfo: nil, repeats: true)
        }
        
    }
    
    func mostrarCadena() {
        self.botonAmarillo.backgroundColor = UIColor.yellowColor()
        self.botonAzul.backgroundColor = UIColor.blueColor()
        self.botonRojo.backgroundColor = UIColor.redColor()
        self.botonVerde.backgroundColor = UIColor.greenColor()

        if self.contTimer == self.limiteMovimientos{
            timer.invalidate()
            
        }
        else {
            if self.juegoArray[self.contTimer] == "amarillo"{
                self.botonAmarillo.backgroundColor = UIColor.whiteColor()
            }
            if self.juegoArray[self.contTimer] == "azul"{
                self.botonAzul.backgroundColor = UIColor.whiteColor()
            }
            if self.juegoArray[self.contTimer] == "rojo"{
                self.botonRojo.backgroundColor = UIColor.whiteColor()
            }
            if self.juegoArray[self.contTimer] == "verde"{
                self.botonVerde.backgroundColor = UIColor.whiteColor()
            }
            println(self.juegoArray[self.contTimer])
        }

        self.contTimer++
        
    }
    
    func buscarPartida(){
        var query = PFQuery(className: "Registro")
        query.whereKey("username", equalTo: self.idMio)
        query.whereKey("contrincante", equalTo: self.idContrincante)
        let result = query.findObjects()
        //self.partida = result["partida"] as String
        self.partida = result[0].objectForKey("partida") as! NSString
        //println(self.partida)
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
