

import UIKit
import RealmSwift



class CrearYEditarNotasYMateriasVC: UIViewController {
    
    let realm                   = try! Realm()
    let formatter               = DateFormatter()
    var queSeEditaOSeCrea       : String?
    var importanciaSeleccionada : String?
    
    //MARK: Outlets
    @IBOutlet weak var viewTitulo: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var textFieldDetalles: UITextField!
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var contenedorDetallesView: UIView!
    @IBOutlet weak var contenedorImportanciaView: UIView!
    @IBOutlet weak var labelFechaEscojida: UILabel!
    @IBOutlet weak var textFieldNombre: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var controlImportanciaOutlet: UISegmentedControl!
    @IBOutlet weak var contenedorNombreView: UIView!
    @IBOutlet weak var contenedorActualizadorFechaView: UIView!
    
    //MARK: Set Up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if crear == true{
            establecerViewParaMateriasONota(editingOrCreating: "Nueva")
        }
        else {
            establecerViewParaMateriasONota(editingOrCreating: "Editar")
            establecerValoresPredeterminadosDeLosOutlets()
            
        }
    }
    
    
    //MARK: Acciones
    
    @IBAction func tocoAfueraDelTextField(_ sender: Any) {
        viewTitle.resignFirstResponder()
    }

    
    @IBAction func tocoAfueraDelTextFieldDeDetalles(_ sender: Any) {
        textFieldDetalles.resignFirstResponder()
    }

    
    @IBAction func accionFechaCambio(_ sender: UIDatePicker) {
        labelFechaEscojida.text = "   \(formatter.string(from: datePicker.date))"
    }

    
    @IBAction func finalizarEditando(_ sender: UIButton) {
        if textFieldNombre.text?.count != 0{
            actualizarCrearMateriaONota()
            if reloadCalendarProjectsTableViewBool == true {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCalendarProjectsTableView"), object: nil)
                reloadCalendarProjectsTableViewBool = false
            }
            self.dismiss(animated: true, completion: nil)
        } else {
            let missingNameAlert = UIAlertController(title: "Parece que te falta algo!", message: "Falta \(queSeEditaOSeCrea!) nombre", preferredStyle: .alert)
            let understoodAction = UIAlertAction(title: "Entendido", style: .cancel)
            missingNameAlert.addAction(understoodAction)
            self.present(missingNameAlert, animated: true, completion: nil)
        }
    }
    
  
    @IBAction func dismissEditingView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func importanciaMateriasSegmentedControl(_ sender: Any) {
        switch  controlImportanciaOutlet.selectedSegmentIndex {
        case 0:
            importanciaSeleccionada = "!!!"
        case 1:
            importanciaSeleccionada = "!!"
        case 2:
            importanciaSeleccionada = "!"
        default:
            break
        }
    }
    
    
    //MARK: Methods
    
    func establecerViewParaMateriasONota(editingOrCreating : String) {
        if segueFuente == 0 {
            if crear == false {
                textFieldNombre.text = materiaSeleccionada!.nombreMateria
                textFieldDetalles.text = materiaSeleccionada!.nombreProfesor
            }
            else {
                textFieldNombre.placeholder = "nombre de materia"
                textFieldDetalles.placeholder = "nombre del profesor"
            }
            contenedorDetallesView.isHidden = false
            contenedorImportanciaView.isHidden = false
            datePicker.isHidden = true
            labelFechaEscojida.isHidden = true
            viewTitle.text = "\(editingOrCreating) materia"
            queSeEditaOSeCrea = "materia"
        } else if segueFuente == 1 {
            if crear == false {
                textFieldNombre.text = notaParaEditar!.nota
                textFieldDetalles.text = notaParaEditar!.detalles
                viewTitle.text = "editar \(notaParaEditar!.nota)"
            } else  {
                textFieldNombre.placeholder = "Nombre de Nota"
                viewTitle.text = "nueva nota de \(materiaSeleccionada!.nombreMateria)"
            }
            datePicker.datePickerMode = .date
            formatter.dateStyle = .full
            contenedorDetallesView.isHidden = false
            contenedorImportanciaView.isHidden = true
            datePicker.isHidden = false
            labelFechaEscojida.text = "   Fecha:"
            queSeEditaOSeCrea = "Nota"
        }
    }
    
    
    func crearMateria() {
        let newProject = Materia()
        newProject.nombreMateria = textFieldNombre.text!
        newProject.nombreProfesor = textFieldDetalles.text!
        newProject.importanciaMateria = importanciaSeleccionada ?? "!!!"
        agregarMateriaAlRealm(project: newProject)
        if segueFuente == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reladMateriasTableView"), object: nil)
            if materiaSeleccionada == nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setBlankTitle"), object: nil)
            }
        }
    }
    
    
    func agregarMateriaAlRealm(project: Materia){
        do {
            try realm.write {
                realm.add(project)
            }
        } catch {
            print(error)
        }
    }
    
    func actualizarMateria() {
        do {
            try realm.write {
                materiaSeleccionada?.nombreMateria = textFieldNombre.text!
    
                materiaSeleccionada?.importanciaMateria = importanciaSeleccionada ?? "!!!"
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reladMateriasTableView"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadCalendarProjectsTableView"), object: nil)
            }
        } catch {
            print(error)
        }
    }
    
    
    func crearNota() {
        let newActivity = Nota()
        newActivity.nota = textFieldNombre.text!
        newActivity.detalles = textFieldDetalles.text!
        newActivity.fecha = formatter.string(from: datePicker.date)
        newActivity.completo = false
        agregarNotaAlRealm(activity: newActivity)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadActivities"), object: nil)
    }
    
    
    func agregarNotaAlRealm(activity : Nota) {
        do {
            try realm.write {
                realm.add(activity)
                materiaSeleccionada!.notas.append(activity)
            }
        } catch {
            print(error)
        }
    }
    
    
    func actualizarNota() {
        do {
            try realm.write {
                notaParaEditar?.nota = textFieldNombre.text!
                notaParaEditar?.detalles = textFieldDetalles.text!
                notaParaEditar?.fecha = formatter.string(from: datePicker.date)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadActivities"), object: nil)
            }
        } catch {
            print(error)
        }
    }

    
    func updateProjectOrActivity() {
        if segueFuente == 0 {
            actualizarMateria()
        } else {
            actualizarNota()
        }
    }
    
    
    func crearMateriaONota() {
        if segueFuente == 0 {
            crearMateria()
        } else if segueFuente == 2 {
            crearMateria()
        } else {
            crearNota()
            }
    }
    
    
    func actualizarCrearMateriaONota() {
        if crear == true {
            crearMateriaONota()
        } else {
            updateProjectOrActivity()
            
        }
    }
    
    
    func establecerValoresPredeterminadosDeLosOutlets() {
        if segueFuente == 0 {
            if materiaSeleccionada?.importanciaMateria == "!!!"{
                controlImportanciaOutlet.selectedSegmentIndex = 0
            }
            else if materiaSeleccionada?.importanciaMateria == "!!"{
                controlImportanciaOutlet.selectedSegmentIndex = 1
            }
            else {
                controlImportanciaOutlet.selectedSegmentIndex = 2
            }
        } else {
            datePicker.date = formatter.date(from: notaParaEditar!.fecha)!
        }
    }
        
    

}
