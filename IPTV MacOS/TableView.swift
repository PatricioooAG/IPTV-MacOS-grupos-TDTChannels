//
//  TableView.swift
//  IPTV MacOS
//
//  Created by Patricio Alberola Gutiérrez on 23/05/2019.
//  Copyright © 2019 Patricio Alberola Gutiérrez. All rights reserved.
//
import Cocoa
import AVKit
import Foundation
import AVFoundation
import Swift



extension ViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        if GlobalVariables.sharedManager.GrupoCadenas == "Grupos" {
        return (GruposArray.count)
        } else {
            return (people.count)

        }
    }
  
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = ArrayTableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
        
        if (tableColumn?.identifier)!.rawValue == "Logo" {
            
            
            if GlobalVariables.sharedManager.GrupoCadenas == "Grupos" {

            
                    
                    cell.imageView?.image = NSImage(named: "iconoGrupo")
            } else {
                
                let person2 = people[row]

                url = URL(string: person2.Logo)!
                
                
                
                let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                    guard let data = data, error == nil else { return }
                    
                    DispatchQueue.main.async() {    // execute on main thread
                        
                        
                        cell.imageView?.image = NSImage(data: data)
                        
                    }
                }
                task.resume()
            }
             
            
        }
        if (tableColumn?.identifier)!.rawValue == "Cadena" {
          
            
            
            if GlobalVariables.sharedManager.GrupoCadenas == "Grupos" {

                let person = GruposArray[row]

            cell.textField?.stringValue = person.Grupo

            } else {
            
                let person2 = people[row]
                cell.textField?.stringValue = person2.Cadena

                
                
            }
        }
        return cell
    }
}


