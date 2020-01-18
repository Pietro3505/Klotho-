import Foundation
import RealmSwift

class Nota : Object {
    
    @objc dynamic var nota     : String = ""
    @objc dynamic var detalles : String = ""
    @objc dynamic var fecha    : String = ""
    @objc dynamic var completo : Bool = false
    
    
    var materiaPadre = LinkingObjects(fromType: Materia.self, property: "notas")
}
