
import Foundation
import RealmSwift

class Materia: Object {
    
    @objc dynamic var nombreMateria      : String = ""
    @objc dynamic var importanciaMateria : String = ""
    @objc dynamic var nombreProfesor     : String = ""
    
    
    let notas = List<Nota>()
    let preguntas = List<Pregunta>()
    let preguntasVF = List<PreguntaVerdaderoFalso>()
}
