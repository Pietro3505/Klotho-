import Foundation
import RealmSwift

class Pregunta : Object {
    
    @objc dynamic var pregunta   : String = ""
    @objc dynamic var respuesta1 : String = ""
    @objc dynamic var respuesta2 : String = ""
    @objc dynamic var respuesta3 : String = ""
    @objc dynamic var respuesta4 : String = ""
    @objc dynamic var correcto1  : Bool = false
    @objc dynamic var correcto2  : Bool = false
    @objc dynamic var correcto3  : Bool = false
    @objc dynamic var correcto4  : Bool = false

    var materiaPadre = LinkingObjects(fromType: Materia.self, property: "preguntas")
}
