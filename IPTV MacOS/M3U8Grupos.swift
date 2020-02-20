//
//  M3U8Grupos.swift
//  IPTV MacOS
//
//  Created by Patricio Alberola Gutiérrez on 02/06/2019.
//  Copyright © 2019 Patricio Alberola Gutiérrez. All rights reserved.
//

import Cocoa
extension String {
    
    func slice2(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
extension String {
    func contains2(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase2(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
class M3U8Grupos: NSObject {
    var contents2 = ""
    var Gruposarr = ""
    var Gruposarr2 = ""

    var index = 0
    func PulirM3u8Grupos() {
        
      
        if let url2 = URL(string: UserDefaults.standard.string(forKey: "Url") ?? "Sin lista cargada") {
            do {
                contents2 = try String(contentsOf: url2)
                //    print(contents)
                //  let str = "sunday, monday, happy days"
                //  for char in str {
                //      print("Found character: \(char)")
                //  }
                let arr2 = contents2.components(separatedBy: "#EXTINF:")
                // print(arr[1])
                
                for _ in arr2 {
                    
                    if index != 0 {
                     
                        
                        if arr2[index].contains2(find: "group-title") {
                            Gruposarr = arr2[index].slice2(from: "group-title=\"", to: "\"")!
                            if Gruposarr == Gruposarr2 {
                                
                            } else {
                                Gruposarr2 = Gruposarr
                              //  print(Gruposarr2)
                                let grupos1 = Grupos.init(Grupo: Gruposarr2)
                                GruposArray.append(grupos1)
                                
                            }
                        
                            
                            
                        }
                        
                        index = index + 1

                    
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
       print(GruposArray)

    }}
