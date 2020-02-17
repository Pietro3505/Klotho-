
import UIKit
import RealmSwift

class PreguntasCuestionarioTVC: UITableViewController {

    let realm = try! Realm()
    
    var añadidoOSeleccionadoMateria : String?
    
    //MARK: Outlets
    
    
    //MARK: Set Up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if  materiaSeleccionada == nil {
            cargarVistaEnBlanco()
        }
        else {
            setearTitulo()
            cargarPreguntas()

        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(cargarPreguntas), name: NSNotification.Name(rawValue: "cargarPreguntas"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recargarPreguntas), name: NSNotification.Name(rawValue: "recargarPreguntas"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setearTitulo), name: NSNotification.Name(rawValue: "setearTitulo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cargarVistaEnBlanco), name: NSNotification.Name(rawValue: "cargarVistaEnBlanco"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    //MARK: TableView Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if preguntas?.count == 0 {
//            return nil
//        }
//        if preguntasVF?.count == 0 {
//            return nil
//        }
//        return view
//    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Opción Multiple"
        } else {
            return "Verdadero o Falso"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if materiaSeleccionada != nil{
            if section == 0 {
                return preguntas?.count ?? 0
                
            } else {
                return preguntasVF?.count ?? 0
            }
        } else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activityCell             = ActivityTableViewCell()
        activityCell.textLabel?.font = UIFont(name: "DIN Alternate", size: 18)
        if indexPath.section == 0 {
            activityCell.textLabel?.text = preguntas?[indexPath.row].pregunta
        } else {
            activityCell.textLabel?.text = preguntasVF?[indexPath.row].afirmacion
        }
        return activityCell
    }
    
    
    //MARK: Acciones
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tipoDePregunta = indexPath.section
        if tipoDePregunta == 0 {
            pregunta = materiaSeleccionada?.preguntas[indexPath.row]
        } else {
            preguntaVF = materiaSeleccionada?.preguntasVF[indexPath.row]
        }
        performSegue(withIdentifier: "MostrarDetallesPregunta", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    

    
    @IBAction func crearPreguntaVC(_ sender: UIBarButtonItem) {
        if materias?.count == 0 {
            añadidoOSeleccionadoMateria = "añadido"
        }
        else {
            añadidoOSeleccionadoMateria = "seleccionado"
        }
        
        if materiaSeleccionada != nil {
            performSegue(withIdentifier: "seleccionarTipoPregunta", sender: self)
        } else {
            let selectProjectFirstAlert = UIAlertController(title: "Parece que te falta algo:", message: "no has \(añadidoOSeleccionadoMateria!) una materia todavia", preferredStyle: .alert)
            let understoodAction = UIAlertAction(title: "Entendido", style: .cancel) { (action) in
            }
            selectProjectFirstAlert.addAction(understoodAction)
            self.present(selectProjectFirstAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func empezarCuestionario(_ sender: Any) {
        if preguntas?.count != 0 || preguntasVF?.count != 0 {
            performSegue(withIdentifier: "MostrarCuestionario", sender: self)
        } else {
            let selectProjectFirstAlert = UIAlertController(title: "Parece que te falta algo:", message: "no has añadido preguntas todavia o seleccionado una materia", preferredStyle: .alert)
            let understoodAction = UIAlertAction(title: "Entendido", style: .cancel) { (action) in
            }
            selectProjectFirstAlert.addAction(understoodAction)
            self.present(selectProjectFirstAlert, animated: true, completion: nil)
        }
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = eliminarPregunta(at: indexPath)
        let edit = editarPreguntaOP(at:indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    
    //MARK: Methods
    
    
    func eliminarPregunta(at indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .normal, title: "Eliminar") { (contextualAction, view, boolValue) in
            boolValue(true)
            let deleteAlert = UIAlertController(title: "¿seguro quieres eliminar esta pregunta?", message: "aviso: esto no se puede deshacer", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Eliminar", style: .destructive) { (action) in
                if indexPath.section == 0 {
                    self.eliminarPreguntaOP(pregunta: (preguntas?[indexPath.row])!)
                } else {
                    self.eliminarPreguntaVF(pregunta: (preguntasVF?[indexPath.row])!)
                }
                
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.reloadData()
            }
            let doNotDeleteAction = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
            }
            deleteAlert.addAction(action)
            deleteAlert.addAction(doNotDeleteAction)
            self.present(deleteAlert, animated: true, completion: nil)
        }
        deleteAction.backgroundColor = .red
        return deleteAction
    }
    
    
    func editarPreguntaOP(at indexPath:IndexPath) -> UIContextualAction {
        let editarAction = UIContextualAction(style: .normal, title: "Editar") { (contextualAction, view, boolValue) in
            boolValue(true)
            editarPregunta = true
            if indexPath.section == 0 {
                preguntaOPParaEditar = preguntas?[indexPath.row]
                self.performSegue(withIdentifier: "editarPreguntaOP", sender: self)
            } else {
                preguntaVFParaEditar = preguntasVF?[indexPath.row]
                self.performSegue(withIdentifier: "editarPreguntaVF", sender: self)
            }
        }
        editarAction.backgroundColor = .gray
        return editarAction
    }
    
    
    func eliminarPreguntaOP(pregunta: Pregunta) {
        do {
            try realm.write {
                realm.delete(pregunta)
            }
        } catch {
            print("\(error)")
        }
    }
    
    
    func eliminarPreguntaVF(pregunta: PreguntaVerdaderoFalso) {
        do {
            try realm.write {
                realm.delete(pregunta)
            }
        } catch {
            print("\(error)")
        }
    }

    
    @objc func setearTitulo() {
        title = "preguntas \(materiaSeleccionada!.nombreMateria) "
    }
    
    
    @objc func cargarVistaEnBlanco() {
        if materias?.count != 0{
            title = "seleccciona una materia primero"
        }
        else {
            title = "añade materias primero"
        }
        tableView.separatorStyle = .none
    }
    
    
    @objc func cargarPreguntas() {
        preguntas = materiaSeleccionada!.preguntas.sorted(byKeyPath: "pregunta", ascending: true)
        preguntasVF = materiaSeleccionada!.preguntasVF.sorted(byKeyPath: "afirmacion", ascending: true)
        tableView.reloadData()
    }
    
    
    @objc func recargarPreguntas() {
        tableView.reloadData()
    }

}
