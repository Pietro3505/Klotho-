import Foundation
import RealmSwift
import Firebase

var projectsOrCalendar                  : Bool?
var materiaSeleccionada                 : Materia?
var materias                            : Results<Materia>?
var preguntas                           : Results<Pregunta>?
var preguntasVF                         : Results<PreguntaVerdaderoFalso>?
var notaParaEditar                      : Nota?
var preguntaOPParaEditar                : Pregunta?
var preguntaVFParaEditar                : PreguntaVerdaderoFalso?
var crear                               : Bool?
var editarPregunta                      : Bool?
var segueFuente                         : Int?
var preguntaFuente                      : Int = 0
var reloadCalendarProjectsTableViewBool : Bool?
var fechaCalendario                     : String?
var indice                              : Int = 0
var tipoDePregunta                      : Int?
var pregunta                            : Pregunta?
var preguntaVF                          : PreguntaVerdaderoFalso?
let materiasReferecne = gdb.collection("Materias")
var gdb = Firestore.firestore()
let almacenamientoEnNube = Storage.storage()
