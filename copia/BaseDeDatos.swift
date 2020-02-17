import Foundation
import Firebase
import FirebaseFirestore

class BaseDeDatos {
    private init() {}
    static let shared = BaseDeDatos()
    
    func crearOEditarTarea(nombre: String, detalles: String, materia: Int, fechaEntrega: String,  horaEntrega: String) {
        let modelo: [String: Any] = ["nombre": nombre, "detalles": detalles, "materia": materia, "fechaEntrega": fechaEntrega,  "horaEntrega": horaEntrega]
        gdb.collection("Tareas").document(nombre).setData(modelo, merge: true)
    }
    
    func eliminar(document: QueryDocumentSnapshot) {
        gdb.collection("Tareas").document(document.documentID).delete()
    }
}
