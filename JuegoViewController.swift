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
    }
    
    @IBAction func oprimiVerde(sender: AnyObject) {
        self.botonVerde.backgroundColor = UIColor.whiteColor()
        self.juegoLocal.append("verde")
    }
    
    @IBAction func oprimiAzul(sender: AnyObject) {
        self.botonAzul.backgroundColor = UIColor.whiteColor()
        self.juegoLocal.append("azul")
    }
    
    @IBAction func oprimiAmarillo(sender: AnyObject) {
        self.botonAmarillo.backgroundColor = UIColor.whiteColor()
        self.juegoLocal.append("amarillo")
    }
    
    func validaArreglo(){
        if self.juegoLocal[self.movimientos] == self.juegoLocal[self.movimientos] {
            self.movimientos++
            if self.movimientos > self.limiteMovimientos {
                //Crear alerta de que se termino el juego
                println(self.juegoLocal)
                //Hacer el pop de la vista
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
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
        self.estaActiva = jugada[0].objectForKey("estaActiva") as Bool
        self.limiteMovimientos = jugada[0].objectForKey("movimientos") as Int
        self.turno = jugada[0].objectForKey("turno") as String
        self.primeraVez = jugada[0].objectForKey("primeraVez") as Bool
        /*if !self.primeraVez {
            self.juegoArray = jugada[0].objectForKey("partida") as [String]
        }*/
        //println(jugada)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buscarPartida(){
        var query = PFQuery(className: "Registro")
        query.whereKey("username", equalTo: self.idMio)
        query.whereKey("contrincante", equalTo: self.idContrincante)
        let result = query.findObjects()
        //self.partida = result["partida"] as String
        self.partida = result[0].objectForKey("partida") as NSString
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
