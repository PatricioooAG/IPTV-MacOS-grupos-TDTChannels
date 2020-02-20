//
//  M3U8.swift
//  IPTV MacOS
//
//  Created by Patricio Alberola Gutiérrez on 21/05/2019.
//  Copyright © 2019 Patricio Alberola Gutiérrez. All rights reserved.
//

import Cocoa

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
class M3U8: NSObject {
    var contents = ""
    var IDEPG = ""
    var UrlLogo = ""
    var NombreEmisora = ""
    var UrlEmisora = ""
    var Gruposarr = ""

    var index = 0
    func PulirM3u8() {
        
        // Buena http://91.121.64.179/tdt_project/output/channels.m3u8
        // https://raw.githubusercontent.com/vk496/IPTVspain/master/spain.m3u8
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
                
                for _ in arr {
                     if index != 0 {
                        
                    
                        if arr[index].contains(find: "group-title") {
                            Gruposarr = arr[index].slice(from: "group-title=\"", to: "\"")!

                        }
                        if  Gruposarr == GlobalVariables.sharedManager.GrupoActual {
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
                        }
                        index = index + 1
                        
                        //   print(people)
                        //   print("-------------------------")
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

}
