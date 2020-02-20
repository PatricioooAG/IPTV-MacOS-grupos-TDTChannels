//
//  ViewController.swift
//  IPTV MacOS
//
//  Created by Patricio Alberola Gutiérrez on 18/05/2019.
//  Copyright © 2019 Patricio Alberola Gutiérrez. All rights reserved.
//

import Cocoa
import AVKit
import Foundation
import AVFoundation




var people: [Person] = []
var GruposArray: [Grupos] = []

var url = URL(string: "")
var LogoPrueba = ""
var player: AVPlayer!
let playerLayer = AVPlayerLayer()

class ViewController: NSViewController {

    @IBOutlet weak var ArrayTableView: NSTableView!
    
    @IBOutlet weak var ImagenFuera: NSImageView!
    
    @IBOutlet weak var Label1: NSTextField!
    
    @IBOutlet weak var Preview: NSView!
    
    @IBOutlet weak var AbrirPantalla: NSButtonCell!
    
    @IBOutlet weak var LogoGrande: NSImageView!
    
    @IBOutlet weak var TxtLista: NSTextField!
    
    @IBOutlet weak var LblLista: NSTextField!
    
    @IBOutlet weak var BtnAtras: NSButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  _ = M3U8().PulirM3u8()
        _ = M3U8Grupos().PulirM3u8Grupos()
        GlobalVariables.sharedManager.GrupoCadenas = "Grupos"
        self.view.window?.minSize = NSSize(width: 775, height: 533)
        BtnAtras.isEnabled = false

         LblLista.stringValue = UserDefaults.standard.string(forKey: "Url") ?? "Sin lista cargada"
    }
    
    var CadenaParaPantalla = ""
   
    func tableViewSelectionDidChange(_ notification: Notification) {
        ArrayTableView.scrollRowToVisible(0)
        if GlobalVariables.sharedManager.GrupoCadenas == "Grupos"{

            let selectedTableView = notification.object as! NSTableView
            let person = GruposArray[selectedTableView.selectedRow]
            //  print(person)
            
            GlobalVariables.sharedManager.GrupoActual = person.Grupo
            LblLista.stringValue = GlobalVariables.sharedManager.GrupoActual
          //  GlobalVariables.sharedManager.GrupoCadenas = "Cadenas"
            GlobalVariables.sharedManager.GrupoCadenas = "Cadenas"
            GlobalVariables.sharedManager.indexTView = selectedTableView.selectedRow
            _ = M3U8().PulirM3u8()
            ArrayTableView.reloadData()
            BtnAtras.isEnabled = true

            
            
        } else {
        
        
        
        
        
        AbrirPantalla.isEnabled = true
        let selectedTableView = notification.object as! NSTableView
        let person = people[selectedTableView.selectedRow]
      //  print(person)
        GlobalVariables.sharedManager.indexTView = selectedTableView.selectedRow

     Label1.stringValue = person.Cadena
        CadenaParaPantalla = person.Cadena
        
        let url = person.UrlCadena
        GlobalVariables.sharedManager.UrlGlobal = url
    
        
        let urlLogo = URL(string: person.Logo)!
        GlobalVariables.sharedManager.Logo = urlLogo

        
        let task = URLSession.shared.dataTask(with: urlLogo) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {    // execute on main thread
                
                
                self.LogoGrande.image = NSImage(data: data)
                
            }
        }
        task.resume()
        
        
        
        
        
        
        playerLayer.frame = Preview.bounds
        Preview.layer?.addSublayer(playerLayer)
        
        let playerItem = AVPlayerItem(url:URL( string:url )! )
        
        
        
        player = AVPlayer(playerItem:playerItem)
        playerLayer.player = player
        player.play()
    }
    }
    
  
    override func viewDidAppear() {
        super.viewDidAppear()
       ArrayTableView.scrollRowToVisible(0)
        //    self.view.window?.delegate = self as? NSWindowDelegate
        self.view.window?.minSize = NSSize(width: 775, height: 533)
    }
    
    
    @IBAction func AbrirPantalla(_ sender: Any) {
        
       
        AbrirPantalla.isEnabled = false
       
        ArrayTableView.reloadData()

        let mainStoryBoard = NSStoryboard(name: "Main", bundle: nil)
        
        
        let windowController = mainStoryBoard.instantiateController(withIdentifier: "Pantalla") as! NSWindowController
        let window = windowController.window
        window?.title = CadenaParaPantalla
        window!.setFrameAutosaveName("preferences")
        windowController.showWindow(self)
        windowController.showWindow(nil)
        
        
        player.replaceCurrentItem(with: nil)
        self.LogoGrande.image = nil
        Label1.stringValue = ""

          }
    
    @IBAction func TDTChannels(_ sender: Any) {
               GruposArray.removeAll()
        AbrirPantalla.isEnabled = false
        UserDefaults.standard.set("http://www.tdtchannels.com/lists/channels.m3u", forKey: "Url")
        _ = M3U8Grupos().PulirM3u8Grupos()

               ArrayTableView.reloadData()
        
    }
    @IBAction func Licencia(_ sender: Any) {
        
        let url = URL(string: "https://github.com/LaQuay/TDTChannels/blob/master/LICENSE")!
        NSWorkspace.shared.open(url)
        
    }
    @IBAction func BtnLista(_ sender: Any) {
        AbrirPantalla.isEnabled = false
        print("wer")
        GruposArray.removeAll()
        UserDefaults.standard.set(TxtLista.stringValue, forKey: "Url")
        LblLista.stringValue = UserDefaults.standard.string(forKey: "Url") ?? "Sin lista cargada"
        _ = M3U8Grupos().PulirM3u8Grupos()

        ArrayTableView.reloadData()
        TxtLista.stringValue = ""


    }
    @IBAction func BtnAtras(_ sender: Any) {
        GlobalVariables.sharedManager.GrupoCadenas = "Grupos"
        people.removeAll()
        ArrayTableView.scrollRowToVisible(0)
      //  _ = M3U8Grupos().PulirM3u8Grupos()
        ArrayTableView.reloadData()
        BtnAtras.isEnabled = false
        LblLista.stringValue = UserDefaults.standard.string(forKey: "Url") ?? "Sin lista cargada"

    }
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

