//
//  GlobalVariables.swift
//  Radio MacOS
//
//  Created by Patricio Alberola Gutiérrez on 7/6/18.
//  Copyright © 2018 Patricio Alberola Gutiérrez. All rights reserved.
//

import Foundation
class GlobalVariables {
    
    // These are the properties you can store in your singleton
   
    var UrlGlobal = ""
    var Logo = URL(string: "")
  var indexTView = 0
    var cadena = ""
    var TotalArray = 0
    var GrupoCadenas = ""
    var GrupoActual = ""
    
    // Here is how you would get to it without there being a global collision of variables.
    // , or in other words, it is a globally accessable parameter that is specific to the
    // class.
    class var sharedManager: GlobalVariables {
        struct Static {
            static let instance = GlobalVariables()
        }
        return Static.instance
    }
}
