import RealmSwift
import UIKit

class CrearPreguntaVFVC: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var cancelarOutlet: UIButton!
    @IBOutlet weak var labelTitulo: UIView!
    @IBOutlet weak var hechoOutlet: UIButton!
    @IBOutlet weak var preguntaLabel: UILabel!
    @IBOutlet weak var nombrePreguntaTextField: UITextField!
    @IBOutlet weak var respuestaLabel: UILabel!
    @IBOutlet weak var verdaderoOFalsoSegmented: UISegmentedControl!
    
    //MARK: Propiedades
    let realm = try! Realm()
    var verdaderoOFalso : Bool = false
    
    //MARK: Set Up
    override func viewDidLoad() {
        super.viewDidLoad()
        if editarPregunta == true {
            setearVistaParaEditar()
        }
    }
    //MARK: Acciones
    
    @IBAction func hechoAccion(_ sender: UIButton) {
        let alerta = UIAlertController(title: "Falta algo...", message: "Asegurate de colocar un nombre a tu pregunta", preferredStyle: .alert)
        alerta.setTitlet(font: UIFont(name: "DIN Alternate", size: 18), color: UIColor.black)
        alerta.setMessage(font: UIFont(name: "DIN Alternate", size: 18), color: UIColor.black)
        let accion = UIAlertAction(title: "Claro!", style: .default) { (accion) in
            }
            alerta.addAction(accion)
        if nombrePreguntaTextField.text?.count == 0{
            present(alerta, animated: true, completion: nil)
        } else {
            if editarPregunta == true {
                actualizarPreguntaVF()
            } else {
                nuevaPreguntaVF()
            }
            dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cargarPreguntas"), object: nil)
        }
    }
    
    @IBAction func cancelarAccion(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
            
    }
    
    @IBAction func verdaderoOFalsoSegmentedAccion(_ sender: UISegmentedControl) {
    switch  verdaderoOFalsoSegmented.selectedSegmentIndex {
          case 0:
            verdaderoOFalso = true
          case 1:
             verdaderoOFalso = false
          default:
              break
        }
    }
    
    //MARK: Metodos
    
    func nuevaPreguntaVF()  {
        let nuevaPregunta        = PreguntaVerdaderoFalso()
        nuevaPregunta.afirmacion = nombrePreguntaTextField.text!
        nuevaPregunta.respuesta  = verdaderoOFalso
        
        do {
              try realm.write {
                realm.add(nuevaPregunta)
                materiaSeleccionada?.preguntasVF.append(nuevaPregunta)
              }
        } catch {
            print(error)
        }
    }
    
    func actualizarPreguntaVF() {
        do {
            try realm.write {
                preguntaVFParaEditar?.afirmacion = nombrePreguntaTextField.text!
                preguntaVFParaEditar?.respuesta = verdaderoOFalso
            }
        } catch {
            print(error)
        }
        editarPregunta = false
    }
    
    
    
    func setearVistaParaEditar(){
        nombrePreguntaTextField.text = preguntaVFParaEditar?.afirmacion
        if preguntaVFParaEditar?.respuesta == true {
            verdaderoOFalsoSegmented.selectedSegmentIndex = 0
        } else {
            verdaderoOFalsoSegmented.selectedSegmentIndex = 1
        }
    }

}
