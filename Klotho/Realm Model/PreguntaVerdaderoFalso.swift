//
//  PreguntaVerdaderoFalso.swift
//  Recuerdamee
//
//  Created by Pablo y Pietro producciones on 11/9/19.
//  Copyright © 2019 Pablo y Pietro SEK Quito. All rights reserved.
//

import Foundation
import RealmSwift

class PreguntaVerdaderoFalso : Object {
    
    @objc dynamic var afirmacion   : String = ""
    @objc dynamic var respuesta    : Bool = false

var materiaPadre = LinkingObjects(fromType: Materia.self, property: "preguntasVF")
}
