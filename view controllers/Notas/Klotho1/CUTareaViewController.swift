import UIKit

class CUTareaViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    

    var hora : DateComponents?
    var fechaEntrega : Date?
    var horaEntrega : String = ""
    let formatter = DateFormatter()
    var imagenes : [String]  = []
    
    @IBOutlet var nombreTareaTF: UITextField!
    @IBOutlet var detallesTareaTF: UITextField!
    @IBOutlet weak var boton: UIButton!
    @IBOutlet weak var datePickerO: UIDatePicker!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nombreTareaTF.text = ""
        nombreTareaTF.isEnabled = true
        formatter.dateStyle = .full
        if crear == true {
            boton.titleLabel?.text = "Crear Tarea"
            nombreTareaTF.text = ""
            nombreTareaTF.isEnabled = true

        } else if crear == false {
            boton.titleLabel?.text = "Editar Tarea"
            nombreTareaTF.text = "\(tareaParaEditar!.documentID)"
            nombreTareaTF.isEnabled = false
        }
        fechaEntrega = datePickerO.date
        hora = Calendar.current.dateComponents([.hour, .minute], from: datePickerO.date )
        if hora!.minute! < 10 {
            horaEntrega = "\(hora!.hour!):0\(hora!.minute!)"
        } else {
            horaEntrega = "\(hora!.hour!):\(hora!.minute!)"

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if crear == true {
            return 1
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fotos", for: indexPath) as!  fotosCell
        cell.foto.image = UIImage(named: "Klotho")
        return cell
    }


    @IBAction func datePicker(_ sender: UIDatePicker) {
        fechaEntrega = datePickerO.date
        hora = Calendar.current.dateComponents([.hour, .minute], from: datePickerO.date )
        if hora!.minute! < 10 {
            horaEntrega = "\(hora!.hour!):0\(hora!.minute!)"
        } else {
            horaEntrega = "\(hora!.hour!):\(hora!.minute!)"

        }
    }
    
    
    
    

    
    @IBAction func crearOEditar(_ sender: UIButton) {
        let modelo : [String : Any] = ["nombre": nombreTareaTF.text!, "detalles": detallesTareaTF.text!, "fechaDeEntrega": formatter.string(from: fechaEntrega!), "horaDeEntrega": horaEntrega, "imagenes" : imagenes]
        if nombreTareaTF.text == "" || detallesTareaTF.text == ""  {
            let alert =  UIAlertController(title: "Te falta algo" , message: "Neceseitas llenar todos los campos primero", preferredStyle: .alert)
            let entendidoAction = UIAlertAction(title: "Entendido", style: .cancel)
            alert.addAction(entendidoAction)
            present(alert, animated: true, completion: nil)
        } else {
            if crear == true {
                materiasReferecne.document(materiaSelected!).collection("Tareas").addDocument(data: modelo)
            }  else {
                
            }
            self.dismiss(animated: true)
            crear = true
        }
    }

}


class fotosCell: UICollectionViewCell {
    @IBOutlet weak var foto: UIImageView!
}
