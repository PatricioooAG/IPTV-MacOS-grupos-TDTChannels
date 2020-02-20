//
//  PantallaControllerView.swift
//  IPTV MacOS
//
//  Created by Patricio Alberola Gutiérrez on 19/05/2019.
//  Copyright © 2019 Patricio Alberola Gutiérrez. All rights reserved.
//

import Cocoa
import AVKit
import Foundation
import AVFoundation


class PantallaControllerView: NSViewController, NSWindowDelegate {
    var OcultarMenu = "oculto"
    var player: AVPlayer!
    let playerLayer = AVPlayerLayer()
    var pausa = "Off"
    var seconds = Float64(0)
    var currentTime = Float64(0)
    var timerMenu:Timer? = Timer()
    var timerMenu2:Timer? = Timer()
   
    var timer:Timer? = Timer()
    var currentValue = Float(0)
    var people: [Person] = []
    var vuelta = "off"
    var TotalArrayLocal = 0
    private var trackingArea: NSTrackingArea?

    @IBOutlet weak var volumeControl: NSSlider!
    
    @IBOutlet weak var ViewControles: NSView!
    
    @IBOutlet var PantallaVideo: NSView!
    
    @IBOutlet weak var LogoControles: NSImageView!
    
    @IBOutlet weak var Pausa: NSButton!
    
    @IBOutlet weak var SliderTiempo: NSSlider!
    
    @IBOutlet weak var LblVivo: NSTextField!
    var contents = ""
    var IDEPG = ""
    var UrlLogo = ""
    var NombreEmisora = ""
    var UrlEmisora = ""
    var Gruposarr = ""

    var index = 0
    
    var urlLocal = GlobalVariables.sharedManager.indexTView

    
    
    
    func PulirM3u8() {
        
       
        if let url = URL(string: UserDefaults.standard.string(forKey: "Url") ?? "Sin lista cargada") {
            do {
                contents = try String(contentsOf: url)
                //    print(contents)
                //  let str = "sunday, monday, happy days"
                //  for char in str {
                //      print("Found character: \(char)")
                //  }
                let arr = contents.components(separatedBy: "#EXTINF:")
                // print(arr[1])
                TotalArrayLocal = GlobalVariables.sharedManager.TotalArray - 1
                for _ in arr {
                    if index != 0 {
                        
                        
                        if arr[index].contains(find: "group-title") {
                            Gruposarr = arr[index].slice(from: "group-title=\"", to: "\"")!

                        }
                        if  Gruposarr == GlobalVariables.sharedManager.GrupoActual {
                            //   print(people)
                            if arr[index].contains("tvg-id") {
                                IDEPG = arr[index].slice(from: "tvg-id=\"", to: "\"")!
                                print(IDEPG)
                            } else {
                                
                                IDEPG = ""
                            }
                            
                            if arr[index].contains("tvg-logo") {
                                UrlLogo = arr[index].slice(from: "tvg-logo=\"", to: "\"")!
                                //      print(UrlLogo!)
                            }
                            
                            NombreEmisora = arr[index].slice(from: ",", to: "\n")!
                            //     print(NombreEmisora!)
                            
                            UrlEmisora = arr[index].slice(from: "\n", to: "\n")!                        //    print(UrlEmisora!)
                            
                            //   ArrayCompleto = [
                            //   ["idEPG": IDEPG, "Logo": UrlLogo, "Cadena": NombreEmisora, "UrlCadena": UrlEmisora]
                            //      ] as! [[String : String]]
                            //  print(ArrayCompleto)
                            //   index = index + 1
                            let person1 = Person.init(idEPG: IDEPG, Logo: UrlLogo, Cadena: NombreEmisora, UrlCadena: UrlEmisora, GruposCad: Gruposarr)
                            people.append(person1)
                            TotalArrayLocal = TotalArrayLocal + 1
                            print(TotalArrayLocal)
                            print("-------------------------")
                            
                        }
                        index = index + 1
                       
                    }else{
                        index = index + 1
                        
                    }
                }
                
            } catch {
                // contents could not be loaded
            }
        } else {
            // the URL was bad!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
PulirM3u8()
        Reproducir()
       ViewControles.wantsLayer = true
        view.layer?.backgroundColor = NSColor.black.cgColor
        
        playerLayer.frame = PantallaVideo.bounds
        PantallaVideo.layer?.addSublayer(playerLayer)
        
       
        if let duration = self.player.currentItem?.asset.duration {
            seconds = CMTimeGetSeconds(duration)
        }
        let stringFloat =  String(describing: seconds)
        
        if stringFloat == "nan" {
            
            SliderTiempo.isHidden = true
            LblVivo.isHidden = false
            if let aTimer = timer {
                aTimer.invalidate()
                timer = nil
            }
            
        } else {
       
            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
            SliderTiempo.isHidden = false
            LblVivo.isHidden = true
        }
        
        

        
        
        
        
            
           

            
        
        let urlLogo = URL(string: people[urlLocal].Logo)!

        
        
        let task = URLSession.shared.dataTask(with: urlLogo) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {    // execute on main thread
                
                
                self.LogoControles.image = NSImage(data: data)
            }
        }
        task.resume()
        
    }
    @objc func fireTimer() {
     //   print("pruebi")
        self.currentTime = CMTimeGetSeconds((self.player.currentTime()))
        self.SliderTiempo.floatValue = Float(self.currentTime/self.seconds)
    }
    func Reproducir() {
        
        
        let fileURL =  GlobalVariables.sharedManager.UrlGlobal
        let playerItem = AVPlayerItem(url:URL( string:fileURL )! )
        
        
        
        player = AVPlayer(playerItem:playerItem)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        playerLayer.player = player
        player.play()
        
    }
    
    @IBAction func adjustVolume(_ sender: Any) {
        
        if player != nil {
            player.volume = volumeControl.floatValue
            currentValue = volumeControl.floatValue
        }}
    
    
 /*   override func mouseDown(with event: NSEvent) {
        
        
        if OcultarMenu == "visible" {
            
            OcultarMenu = "oculto"
            
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                context.duration = 3
                self.view.window?.standardWindowButton(NSWindow.ButtonType.closeButton)!.superview?.animator().alphaValue = 0
                
                self.view.window?.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.superview?.animator().alphaValue = 0
                
                self.view.window?.standardWindowButton(NSWindow.ButtonType.zoomButton)!.superview?.animator().alphaValue = 0
                
                self.view.window?.titlebarAppearsTransparent = true
                
                volumeControl.superview?.animator().alphaValue = 0
                
                
            })
            
            volumeControl.isEnabled = false

            
        } else {
            
            OcultarMenu = "visible"
            
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                context.duration = 3
                self.view.window?.standardWindowButton(NSWindow.ButtonType.closeButton)!.superview?.animator().alphaValue = 1
                
                self.view.window?.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.superview?.animator().alphaValue = 1
                
                self.view.window?.standardWindowButton(NSWindow.ButtonType.zoomButton)!.superview?.animator().alphaValue = 1
                
                self.view.window?.titlebarAppearsTransparent = false
                
                volumeControl.superview?.animator().alphaValue = 1

            })
            volumeControl.isEnabled = true
        }
    }
 */
    override func viewDidAppear() {
        super.viewDidAppear()
        player.volume = volumeControl.floatValue
        currentValue = volumeControl.floatValue
        view.window?.delegate = self
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 1.5
            self.view.window?.standardWindowButton(NSWindow.ButtonType.closeButton)!.superview?.animator().alphaValue = 0
            
            self.view.window?.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.superview?.animator().alphaValue = 0
            
            self.view.window?.standardWindowButton(NSWindow.ButtonType.zoomButton)!.superview?.animator().alphaValue = 0
            
            self.view.window?.titlebarAppearsTransparent = true
            
            LogoControles.superview?.animator().alphaValue = 0

       })
     
        if (trackingArea == nil) {
            trackingArea = NSTrackingArea(rect: self.view.bounds, options: [.activeAlways, .mouseMoved], owner: self, userInfo: nil)
            self.view.addTrackingArea(trackingArea!)
        }
       ViewControles.layer?.backgroundColor = NSColor.blue.withAlphaComponent(0.8).cgColor
       ViewControles.layer?.cornerRadius = 16
        self.view.window?.aspectRatio = NSSize(width: 16, height: 9)


    //    self.view.window?.delegate = self as? NSWindowDelegate
        self.view.window?.minSize = NSSize(width: 470, height: 264)
    }
    
    
    @IBAction func BtnPlay(_ sender: Any) {
        
        let fileURL =  people[urlLocal].UrlCadena
        
        if pausa == "On" {
            Pausa.image = NSImage(named: "Pause")
            pausa = "Off"
        }
        let playerItem = AVPlayerItem(url:URL( string:fileURL )! )
        
        
        
        player = AVPlayer(playerItem:playerItem)
        playerLayer.player = player
        player.play()
        volumeControl.floatValue = currentValue
        player.volume = currentValue
    }
    
    @IBAction func BtnPause(_ sender: Any) {
        if pausa == "Off" {
            
            player.pause()
            pausa = "On"
            Pausa.image = NSImage(named: "Pausa")
        } else {
            
            player.play()
            pausa = "Off"
            Pausa.image = NSImage(named: "Pause")
        }
    }
    
    @IBAction func BtnStop(_ sender: Any) {
        player.replaceCurrentItem(with: nil)
        if pausa == "On" {
            Pausa.image = NSImage(named: "Pause")
            pausa = "Off"
        }
    }
    
    @IBAction func BtnAtras(_ sender: Any) {
        _ = people[urlLocal]


        if let aTimer2 = timerMenu2 {
            aTimer2.invalidate()
            timerMenu2 = nil
        }
     //   print(person)
        
  //      GlobalVariables.sharedManager.TotalArray
        
        if urlLocal == 0 {
urlLocal = TotalArrayLocal
            vuelta = "on"
        }
        if vuelta == "on" {
            vuelta = "off"
            
        } else {
            urlLocal = urlLocal - 1
        }
  
     
      
        
        self.view.window?.title = people[urlLocal].Cadena
        
        
        
        
      
        
        if let aTimer = timerMenu {
            aTimer.invalidate()
            timerMenu = nil
        }
        print("moving")
        if isMouseInView(view: ViewControles) == true {
            
            print("dentro")
        } else {
            timerMenu = Timer.scheduledTimer(timeInterval: 3.2, target: self, selector: #selector(fireTimerMenu), userInfo: nil, repeats: false)
        }
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 1.5
            self.view.window?.standardWindowButton(NSWindow.ButtonType.closeButton)!.superview?.animator().alphaValue = 1
            
            self.view.window?.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.superview?.animator().alphaValue = 1
            
            self.view.window?.standardWindowButton(NSWindow.ButtonType.zoomButton)!.superview?.animator().alphaValue = 1
            
            self.view.window?.titlebarAppearsTransparent = false
            
            LogoControles.superview?.animator().alphaValue = 1
            
        })
        timerMenu2 = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(fireTimerMenu2), userInfo: nil, repeats: false)
       }
    
    @IBAction func BtnAdelante(_ sender: Any) {
        
        _ = people[urlLocal]
        
        
        if let aTimer = timerMenu2 {
            aTimer.invalidate()
            timerMenu2 = nil
        }
        //   print(person)
        
        //      GlobalVariables.sharedManager.TotalArray
        if urlLocal == TotalArrayLocal {

            urlLocal = 0
            vuelta = "on"
        }
        if vuelta == "on" {
            vuelta = "off"

        } else {
        urlLocal = urlLocal + 1
        }
            
       
       
       
     
        
        self.view.window?.title = people[urlLocal].Cadena
        
        
        
        
       
        
        if let aTimer = timerMenu {
            aTimer.invalidate()
            timerMenu = nil
        }
        print("moving")
        if isMouseInView(view: ViewControles) == true {
            
            print("dentro")
        } else {
            timerMenu = Timer.scheduledTimer(timeInterval: 3.2, target: self, selector: #selector(fireTimerMenu), userInfo: nil, repeats: false)
        }
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 1.5
            self.view.window?.standardWindowButton(NSWindow.ButtonType.closeButton)!.superview?.animator().alphaValue = 1
            
            self.view.window?.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.superview?.animator().alphaValue = 1
            
            self.view.window?.standardWindowButton(NSWindow.ButtonType.zoomButton)!.superview?.animator().alphaValue = 1
            
            self.view.window?.titlebarAppearsTransparent = false
            
            LogoControles.superview?.animator().alphaValue = 1
            
        })
        timerMenu2 = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(fireTimerMenu2), userInfo: nil, repeats: false)

    }
    @objc func fireTimerMenu2() {
        player.replaceCurrentItem(with: nil)

        let fileURL =  people[urlLocal].UrlCadena

        let playerItem = AVPlayerItem(url:URL( string:fileURL )! )
        
        if pausa == "On" {
        Pausa.image = NSImage(named: "Pause")
        pausa = "Off"
        }
        player = AVPlayer(playerItem:playerItem)
        playerLayer.player = player
        player.play()
        volumeControl.floatValue = currentValue
        player.volume = currentValue
        let urlLogo = URL(string: people[urlLocal].Logo)!

        let task = URLSession.shared.dataTask(with: urlLogo) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {    // execute on main thread
                
                
                self.LogoControles.image = NSImage(data: data)
            }
        }
        task.resume()
        if let duration = self.player.currentItem?.asset.duration {
            seconds = CMTimeGetSeconds(duration)
        }
        let stringFloat =  String(describing: seconds)
        
        if stringFloat == "nan" {
            self.SliderTiempo.floatValue = 0
            SliderTiempo.isHidden = true
            LblVivo.isHidden = false
            if let aTimer = timer {
                aTimer .invalidate()
                timer = nil
            }
            
            
        } else {
            self.SliderTiempo.floatValue = 0

            timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
            SliderTiempo.isHidden = false
            LblVivo.isHidden = true
        }
    }
    func windowWillClose(_ notification: Notification) {
        print("willClose")
        player.replaceCurrentItem(with: nil)
        if let aTimer = timer {
            aTimer.invalidate()
            timer = nil
        }
    }
    
    override func mouseMoved(with event: NSEvent) {
        if let aTimer = timerMenu {
            aTimer.invalidate()
            timerMenu = nil
        }
        print("moving")
        if isMouseInView(view: ViewControles) == true {
            
            print("dentro")
        } else {
            timerMenu = Timer.scheduledTimer(timeInterval: 3.2, target: self, selector: #selector(fireTimerMenu), userInfo: nil, repeats: true)
        }
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 1.5
            self.view.window?.standardWindowButton(NSWindow.ButtonType.closeButton)!.superview?.animator().alphaValue = 1
            
            self.view.window?.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.superview?.animator().alphaValue = 1
            
            self.view.window?.standardWindowButton(NSWindow.ButtonType.zoomButton)!.superview?.animator().alphaValue = 1
            
            self.view.window?.titlebarAppearsTransparent = false
            
            LogoControles.superview?.animator().alphaValue = 1
            
        })
    
       
    }
    @objc func fireTimerMenu() {
        
       
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 1.5
            self.view.window?.standardWindowButton(NSWindow.ButtonType.closeButton)!.superview?.animator().alphaValue = 0
            
            self.view.window?.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)!.superview?.animator().alphaValue = 0
            
            self.view.window?.standardWindowButton(NSWindow.ButtonType.zoomButton)!.superview?.animator().alphaValue = 0
            
            self.view.window?.titlebarAppearsTransparent = true
            
            LogoControles.superview?.animator().alphaValue = 0
            
        })
    }
    
    
 
        
    func windowDidResize(_ notification: Notification) {

    
            trackingArea = NSTrackingArea(rect: self.view.bounds, options: [.activeAlways, .mouseMoved], owner: self, userInfo: nil)
            self.view.addTrackingArea(trackingArea!)
        
        }
    func isMouseInView(view: NSView) -> Bool? {
        if let window = view.window {
            return view.isMousePoint(window.mouseLocationOutsideOfEventStream, in: view.frame)
        }
        return nil
    }
    }
