
import UIKit
import Firebase



class Tareas_Preguntas: UITableViewController {
    
    var materia : DocumentReference?
    var tareasRF : [QueryDocumentSnapshot] = []
    var preguntasVF : [QueryDocumentSnapshot] = []
    var preguntasOP : [QueryDocumentSnapshot] = []
    


    override func viewDidLoad() {
        super.viewDidLoad()
        if materiaSelected != nil {
            materia = materiasReferecne.document(materiaSelected!)
            addSnapshitListenerTareas()
            addSnapshitListenerPreguntasOP()
            addSnapshitListenerPreguntasVF()
            print(tareasRF.count)
            if  tareasOPreguntas == true {
                setViewForTareas()
            } else {
                setViewForPreguntas()
            }
        } else {
            setDeafaultView()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    
    @IBAction func crearPreguntasOTareas(_ sender: Any) {
        if tareasOPreguntas == true {
            performSegue(withIdentifier: "CUTareas", sender: self)
        } else {
            performSegue(withIdentifier: "CUPreguntas", sender: self)
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if materiaSelected != nil {
            if tareasOPreguntas == true {
                return 1
            } else {
                return 2
            }
        } else {
            return 0
        }
       
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if materiaSelected !=  nil {
            if tareasOPreguntas == true {
                return tareasRF.count
            } else {
                if section == 0 {
                    return preguntasOP.count
                } else {
                    return preguntasVF.count
                }
            }
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tareasOPreguntas == true {
           return cellForRowTareas(cellForRowAT: indexPath)
        } else {
            if indexPath.section == 0 {
                return cellForRowPreguntasOP(cellForRowAT: indexPath)
            } else {
                return cellForRowPreguntasVF(cellForRowAT: indexPath)
            }
        }
    }



    // MARK: - Tareas data
    
    func addSnapshitListenerTareas() {
        materia!.collection("Tareas").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error retreiving collection: \(error)")
            }
            self.tareasRF.removeAll()
            for document in querySnapshot!.documents {
                print("\(document.documentID)")
                self.tareasRF.append(document)
                print(self.tareasRF.count)
            }
            print("numero de taeras: \(self.tareasRF.count)")
            self.tableView.reloadData()
        }
    }
    
    func setViewForTareas() {
        title = "Tareas de \(nombreMateria!)"
    }

    func cellForRowTareas(cellForRowAT indexpath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "tareas_PreguntasCells", for: indexpath) as!  TareaTableViewCell
        let tarea = tareasRF[indexpath.row]
        cell.tarea_preguntaTextLabel.text = "\(tarea.get("nombre")!)"
        cell.fechaDeEntrega_pulsaParaDetallesTextLabel.text = "\(tarea.get("fechaDeEntrega")!) / \(tarea.get("horaDeEntrega")!)"
        if tarea.get("entregado") as! Bool == true {
            cell.entregado_pendiente.text = "Entregado"
        } else {
            cell.entregado_pendiente.text = "Pendiente"
        }
        cell.pulsaParaVerDetallesTextLabel.text = "Pulsa para ver detalles"
        
        return cell
    }

    // MARK: -Praguntas data
    
    func addSnapshitListenerPreguntasVF() {
        materia!.collection("Preguntas").document("VF").collection("Preguntas").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error retreiving collection: \(error)")
            }
            self.preguntasVF.removeAll()
            for document in querySnapshot!.documents {
                print("\(document.documentID)")
                self.preguntasVF.append(document)
                print(self.preguntasVF.count)
            }
            print("numero de preguntas: \(self.preguntasVF.count)")
            self.tableView.reloadData()
        }
    }
    
    func addSnapshitListenerPreguntasOP() {
        materia!.collection("Preguntas").document("OP").collection("Preguntas").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error retreiving collection: \(error)")
            }
            self.preguntasOP.removeAll()
            for document in querySnapshot!.documents {
                print("\(document.documentID)")
                self.preguntasOP.append(document)
                print(self.preguntasOP.count)
            }
            print("numero de preguntas: \(self.preguntasOP.count)")
            self.tableView.reloadData()
        }
    }

    func setViewForPreguntas(){
        title = "preguntas de \(nombreMateria!)"
    }
    
    func cellForRowPreguntasVF(cellForRowAT indexpath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "tareas_PreguntasCells", for: indexpath) as!  TareaTableViewCell
        let pregunta = preguntasVF[indexpath.row]
        cell.tarea_preguntaTextLabel.text = "\(pregunta.get("nombre")!)"
        cell.fechaDeEntrega_pulsaParaDetallesTextLabel.text = "Pulsa para ver detalles"
        cell.entregado_pendiente.text = ""
        cell.pulsaParaVerDetallesTextLabel.text = ""
        return cell
    }
    
    func cellForRowPreguntasOP(cellForRowAT indexpath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "tareas_PreguntasCells", for: indexpath) as!  TareaTableViewCell
        let pregunta = preguntasOP[indexpath.row]
        cell.tarea_preguntaTextLabel.text = "\(pregunta.get("nombre")!)"
        cell.fechaDeEntrega_pulsaParaDetallesTextLabel.text = "Pulsa para ver detalles"
        cell.entregado_pendiente.text = ""
        cell.pulsaParaVerDetallesTextLabel.text = ""
        return cell
    }
    
// MARK: -Other Methods
    
    func setDeafaultView() {
        if tareasOPreguntas == true {
            title = "Tareas"
        } else {
            title = "Preguntas"
        }
    }

}


class TareaTableViewCell : UITableViewCell {
   
    @IBOutlet weak var tarea_preguntaTextLabel: UILabel!
    @IBOutlet weak var fechaDeEntrega_pulsaParaDetallesTextLabel: UILabel!
    @IBOutlet weak var pulsaParaVerDetallesTextLabel: UILabel!
    @IBOutlet weak var entregado_pendiente: UILabel!
}
