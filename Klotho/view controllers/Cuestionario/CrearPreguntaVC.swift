
import UIKit
import RealmSwift

class CrearPreguntaVC: UIViewController {

    //MARK: Propiedades
    let realm            = try! Realm()
    var correcto1 : Bool = false
    var correcto2 : Bool = false
    var correcto3 : Bool = false
    var correcto4 : Bool = false
    
    //MARK: Outlets
    @IBOutlet weak var cancelar: UIButton!
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var hecho: UIButton!
    @IBOutlet weak var preguntaTF: UITextField!
    @IBOutlet weak var respuesta1TF: UITextField!
    @IBOutlet weak var respuesta2TF: UITextField!
    @IBOutlet weak var respuesta3TF: UITextField!
    @IBOutlet weak var respuesta4TF: UITextField!
    @IBOutlet weak var switchR1: UISwitch!
    @IBOutlet weak var switchR2: UISwitch!
    @IBOutlet weak var switchR3: UISwitch!
    @IBOutlet weak var switchR4: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchR1.onTintColor = UIColor("#3D81AD")
        switchR2.onTintColor = UIColor("#3D81AD")
        switchR3.onTintColor = UIColor("#3D81AD")
        switchR4.onTintColor = UIColor("#3D81AD")
        switchR1.isOn        = false
        switchR2.isOn        = false
        switchR3.isOn        = false
        switchR4.isOn        = false
        if editarPregunta == true {
            setearVistaParaEditar()
        }
    }
    
    
    //MARK: Acciones
    @IBAction func CancelarAccion(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func HechoAccion(_ sender: UIButton) {
        
        let alerta = UIAlertController(title: "Falta algo...", message: "Llena todos los espacios antes de comenzar y selecciona las respuestas correctas", preferredStyle: .alert)
        alerta.setTitlet(font: UIFont(name: "DIN Alternate", size: 18), color: UIColor.black)
        alerta.setMessage(font: UIFont(name: "DIN Alternate", size: 18), color: UIColor.black)
        let accion = UIAlertAction(title: "Claro!", style: .default) { (accion) in
            
        }
        alerta.addAction(accion)
        
        if ((preguntaTF?.text?.count) != 0) && (respuesta1TF!.text?.count != 0) && (respuesta2TF!.text?.count != 0) && (respuesta3TF!.text?.count != 0) && respuesta4TF!.text?.count != 0 {
            if correcto1 || correcto2 || correcto3 || correcto4 != false {
                if editarPregunta == true {
                    actualizarPregunta()
                } else {
                    crearPregunta()
                }
                dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cargarPreguntas"), object: nil)
            } else {
                present(alerta, animated: true)
            }
            } else {
            present(alerta, animated: true)
        }
        
    }
    
    
    @IBAction func Switch1A(_ sender: UISwitch) {
        if switchR1.isOn {
           correcto1 = true
          
        } else {
            correcto1 = false
            }
    }
    @IBAction func Switch2A(_ sender: UISwitch) {
        if switchR2.isOn {
           correcto2 = true
          
        } else {
            correcto2 = false
            }
    }
    @IBAction func Switch3A(_ sender: UISwitch) {
        if switchR3.isOn {
            correcto3 = true
      
        } else {
            correcto3 = false
        }
    }
    @IBAction func Switch4A(_ sender: UISwitch) {
        if switchR4.isOn {
           correcto4 = true
          
        } else {
            correcto4 = false
            }
    }
    
    
    //MARK: Metododos
    func crearPregunta()  {
        let nuevaPregunta = Pregunta()
        nuevaPregunta.pregunta   = preguntaTF.text!
        nuevaPregunta.respuesta1 = respuesta1TF.text!
        nuevaPregunta.respuesta2 = respuesta2TF.text!
        nuevaPregunta.respuesta3 = respuesta3TF.text!
        nuevaPregunta.respuesta4 = respuesta4TF.text!
        nuevaPregunta.correcto1  = correcto1
        nuevaPregunta.correcto2  = correcto2
        nuevaPregunta.correcto3  = correcto3
        nuevaPregunta.correcto4  = correcto4
        do {
            try realm.write {
                realm.add(nuevaPregunta)
                materiaSeleccionada?.preguntas.append(nuevaPregunta)
            }
        } catch  {
            print(error)
        }
    }
    
    func actualizarPregunta() {
        do {
            try realm.write {
                preguntaOPParaEditar?.pregunta = preguntaTF.text!
                preguntaOPParaEditar?.respuesta1 = respuesta1TF.text!
                preguntaOPParaEditar?.respuesta2 = respuesta2TF.text!
                preguntaOPParaEditar?.respuesta3 = respuesta3TF.text!
                preguntaOPParaEditar?.respuesta4 = respuesta4TF.text!
                preguntaOPParaEditar!.correcto1  = correcto1
                preguntaOPParaEditar!.correcto2  = correcto2
                preguntaOPParaEditar!.correcto3  = correcto3
                preguntaOPParaEditar!.correcto4  = correcto4
            }
        } catch {
            print(error)
        }
        editarPregunta = false

    }
    
    func setearVistaParaEditar() {
        viewTitle.text = "Editar Pregunta"
        preguntaTF.text = "\(preguntaOPParaEditar?.pregunta ?? "")"
        respuesta1TF.text = "\(preguntaOPParaEditar?.respuesta1 ?? "")"
        respuesta2TF.text = "\(preguntaOPParaEditar?.respuesta2 ?? "")"
        respuesta3TF.text = "\(preguntaOPParaEditar?.respuesta3 ?? "")"
        respuesta4TF.text = "\(preguntaOPParaEditar?.respuesta4 ?? "")"
        if preguntaOPParaEditar?.correcto1 == true {
            switchR1.isOn = true
            correcto1 = true
        }
        if preguntaOPParaEditar?.correcto2 == true {
            switchR2.isOn = true
            correcto2 = true
        }
        if preguntaOPParaEditar?.correcto3 == true {
            switchR3.isOn = true
            correcto3 = true
        }
        if preguntaOPParaEditar?.correcto4 == true {
            switchR4.isOn = true
            correcto4 = true
        }
    }

    
}
