import UIKit
import RealmSwift

class DetallePreguntaVC: UIViewController {
    
    let realm = try! Realm()
    
    
    
    
    @IBOutlet weak var preguntaLabel: UILabel!
    @IBOutlet weak var respuesta1Label: UILabel!
    @IBOutlet weak var respuesta2Label: UILabel!
    @IBOutlet weak var respuesta3Label: UILabel!
    @IBOutlet weak var respuesta4Label: UILabel!
    @IBOutlet weak var respuesta1View: UIView!
    @IBOutlet weak var respuesta2View: UIView!
    @IBOutlet weak var respuesta3View: UIView!
    @IBOutlet weak var respuesta4View: UIView!
    @IBOutlet weak var vistaRespuestas: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //if tipoDePregunta == 0 {
            title                = "\(materiaSeleccionada?.nombreMateria ?? "")"
            preguntaLabel.text   = "   \(pregunta?.pregunta ?? "")"
            respuesta1Label.text = "   \(pregunta?.respuesta1 ?? "")"
            respuesta2Label.text = "   \(pregunta?.respuesta2 ?? "")"
            respuesta3Label.text = "   \(pregunta?.respuesta3 ?? "")"
            respuesta4Label.text = "   \(pregunta?.respuesta4 ?? "")"
            
        //} else {
//            respuesta4View.isHidden = true
//            respuesta4Label.isHidden = true
//            respuesta3View.isHidden = true
//            respuesta3Label.isHidden = true
//            vistaRespuestas.backgroundColor = .groupTableViewBackground
//            preguntaLabel.text = "   \(preguntaVF?.afirmacion ?? "")"
//            respuesta1Label.text = "Verdadero"
//            respuesta4Label.text = "Falso"
        //}
        setearColorRespuestas()
        respuesta1View.layer.cornerRadius = 20
        respuesta2View.layer.cornerRadius = 20
        respuesta3View.layer.cornerRadius = 20
        respuesta4View.layer.cornerRadius = 20
    }
    

    func setearColorRespuestas() {
//        if tipoDePregunta == 0 {
            if pregunta?.correcto1 ==  false {
                respuesta1View.backgroundColor = UIColor("#D65030")
            } else  {
                respuesta1View.backgroundColor = UIColor("#1DB689")
            }
            if pregunta?.correcto2 ==  false {
                respuesta2View.backgroundColor = UIColor("#D65030")
            } else  {
                respuesta2View.backgroundColor = UIColor("#1DB689")
            }
            if pregunta?.correcto3 ==  false {
                respuesta3View.backgroundColor = UIColor("#D65030")
            } else  {
                respuesta3View.backgroundColor = UIColor("#1DB689")
            }
            if pregunta?.correcto4 ==  false {
                respuesta4View.backgroundColor = UIColor("#D65030")
            } else  {
                respuesta4View.backgroundColor = UIColor("#1DB689")
            }
//        } else {
//            if  preguntaVF?.respuesta == true {
//                respuesta1View.backgroundColor = UIColor("#1DB689")
//                respuesta2View.backgroundColor = UIColor("#D65030")
//            } else {
//                respuesta1View.backgroundColor = UIColor("#D65030")
//                respuesta2View.backgroundColor = UIColor("#1DB689")
//            }
//        }
       
    }
}
