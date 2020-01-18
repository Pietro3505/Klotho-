import UIKit
import RealmSwift
import HexColors




class InicioVC: UIViewController {
    
    let realm = try! Realm()
    var canciones : Results<Musica>!

    //MARK:  Outlets


    @IBOutlet weak var projectsOutlet: UIButton!
    @IBOutlet weak var calendarOutlet: UIButton!
    @IBOutlet weak var settingsOutlet: UIButton!
    @IBOutlet weak var iView: UIImageView!
    @IBOutlet weak var outletQuestionario: BotonP!
    
    
    //MARK: Set up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice().userInterfaceIdiom == .phone {
            iView.image = UIImage(named: "Imagen Iphone")
        }
        if UIDevice().userInterfaceIdiom == .pad {
            iView.image = UIImage(named: "Imagen Ipad")
        if UIDevice().orientation == .landscapeLeft  {
             iView.image = UIImage(named: "Imagen Ipad")
        } else if UIDevice().orientation == .landscapeRight {
            iView.image = UIImage(named: "Imagen Ipad")
        } else if UIDevice().orientation == .portrait {
            iView.image = UIImage(named: "Imagen Iphone")
        } else if UIDevice().orientation == .portraitUpsideDown {
            iView.image = UIImage(named: "Imagen Iphone")
        }
        }
        projectsOutlet.setTitle("Mis Notas", for: .normal)
        calendarOutlet.setTitle("Calendario", for: .normal)
        settingsOutlet.setTitle("...", for: .normal)
        outletQuestionario.setTitle("Cuestionario", for: .normal)
        settingsOutlet.layer.cornerRadius = 10
        iView.layer.cornerRadius          = 20
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        canciones = realm.objects(Musica.self)
             if canciones.count == 0 {
                 reproductor.compartido.play(nombre: "Mozart")
                 crearCancion(nombre: "Mozart")
             }
         if canciones.last?.musicaED == false {
         reproductor.compartido.play(nombre: canciones?.last?.cancionEscojida ?? "Mozart")
         reproductor.compartido.cambiarVolumen(volumen: canciones.last?.volumenR ?? 0)
             }
    }
    
    
    @IBAction func calendarAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toCalendarVC", sender: self)
    }
    
    
    @IBAction func startAction(_ sender: UIButton) {
        performSegue(withIdentifier: "toProjectsVC" , sender: self )
        materiaSeleccionada = nil
    }
    
    
    @IBAction func haciaCuestionario(_ sender: Any) {
        performSegue(withIdentifier: "haciaCuestionario" , sender: self )
        materiaSeleccionada = nil
    }
    
    
    //MARK: Metodos
    func crearCancion(nombre : String)  {
         let nuevaC = Musica()
         nuevaC.cancionEscojida = nombre
         nuevaC.musicaED        = false
         nuevaC.volumenR        = 0.5
         do {
             try realm.write {
                 realm.add(nuevaC)
             }
         } catch  {
             print(error)
         }
     }
    
    
}
