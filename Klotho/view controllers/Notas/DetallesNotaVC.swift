import UIKit
import RealmSwift

class DetallesNotaVC: UIViewController {
    
    let realm = try! Realm()
    var actividadDetallada : Nota?
    let formatter = DateFormatter()

    @IBOutlet weak var contenedorDetalles: UIView!
    @IBOutlet weak var DetallesActividad: UILabel!
    @IBOutlet weak var labelDeFechaDeRealizacion: UILabel!
    @IBOutlet weak var establecerStatusDeCompletadoParaNotasOutlet: UISegmentedControl!
    @IBOutlet weak var eliminarActividadOutlet: UIButton!
    @IBOutlet weak var contenedorStatusCompletado: UIView!
    @IBOutlet weak var labelMarcarComoCompletado: UILabel!
    @IBOutlet weak var tituloDeDetalles: UILabel!
    @IBOutlet weak var tituloAlertaFecha: UILabel!
    @IBOutlet weak var contenedorAlertaFecha: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarF(color: "#3D81AD")
        title                  = actividadDetallada?.nota
        DetallesActividad.text = actividadDetallada?.detalles
        formatter.dateStyle    = .full
        formatter.timeStyle    = .short
        labelDeFechaDeRealizacion.text = actividadDetallada!.fecha
        establecerSegmentedControl()
        if actividadDetallada?.detalles == "" {
            contenedorDetalles.isHidden = true
        }
    } 
    
    
    @IBAction func eliminarActividadBoton(_ sender: UIButton) {
        do {
            try realm.write {
                realm.delete(actividadDetallada!)
            }
        } catch {
            print(error)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cambiarStatusDeLaActividadAccion(_ sender: Any) {
        switch establecerStatusDeCompletadoParaNotasOutlet.selectedSegmentIndex {
        case 0:
            cambiarStatusDeLaActividad(status: false)
        case 1:
            cambiarStatusDeLaActividad(status: true)
        default:
         break
        }
    }
    
    
    func cambiarStatusDeLaActividad(status: Bool){
        do {
            try realm.write {
                actividadDetallada?.completo = status
            }
        } catch {
            print(error)
        }
    }
    
    
    func establecerSegmentedControl() {
        if actividadDetallada?.completo == true {
            establecerStatusDeCompletadoParaNotasOutlet.selectedSegmentIndex = 1
        } else {
            establecerStatusDeCompletadoParaNotasOutlet.selectedSegmentIndex = 0
        }
    }
    func navBarF (color : String) {
             guard let navBar       = navigationController?.navigationBar else {fatalError("Navigation controller no existe")}
             guard let navBarColour = UIColor("#3D81AD") else { fatalError()}
             navBar.barTintColor    = navBarColour
             navBar.tintColor       = UIColor.white
             let textAttributes     = [NSAttributedString.Key.font : UIFont(name: "DIN Alternate", size: 18), NSAttributedString.Key.foregroundColor:UIColor.white]
             let textAttributes1    = [NSAttributedString.Key.font : UIFont(name: "DIN Alternate", size: 50), NSAttributedString.Key.foregroundColor:UIColor.white]
             navBar.titleTextAttributes      = textAttributes as [NSAttributedString.Key : Any]
             navBar.largeTitleTextAttributes = textAttributes1 as [NSAttributedString.Key : Any]
               }
}
