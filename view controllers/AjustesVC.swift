import UIKit
import RealmSwift

class AjustesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Prtopiedades
    let realm      = try! Realm()
    let musicaArray = ["Mozart", "Beethoven","Vivaldi","Johann Bach","Schubert","Wagner","Chopin","Haydn","Schumann","Liszt"]
    var canciones  : Results<Musica>!
    
    //MARK: Outlets
    
    @IBOutlet weak var labelEsta: UILabel!
    @IBOutlet weak var deleteAllProjectsOutlet: UIButton!
    @IBOutlet weak var labelEncender: UILabel!
    @IBOutlet weak var labelVolumen: UILabel!
    @IBOutlet weak var sliderVolumen: UISlider!
    @IBOutlet weak var viewSlider: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchEncender: UISwitch!
    @IBOutlet weak var viewLabel: UIView!
    

    //MARK: Set Up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canciones = realm.objects(Musica.self)
        switchEncender.onTintColor    = UIColor("#000000000000")
        viewLabel.layer.cornerRadius  = 20
        viewSlider.layer.cornerRadius = 20
        deleteAllProjectsOutlet.titleLabel?.font = UIFont(name: "DIN Alternate", size: 18)
    if canciones.last?.musicaED == false {
          switchEncender.isOn = true
        labelEsta.text = "Esta sonando \(canciones.last?.cancionEscojida ?? "Mozart")"
      } else{
          switchEncender.isOn    = false
          labelEsta.text = "Música detenida"
      }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicaArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        cell.textLabel?.text = musicaArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: "DIN Alternate", size: 18)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                tableView.deselectRow(at: indexPath, animated: true)
        if canciones.last?.musicaED == false {
        let alerta = UIAlertController(title: "Deseas Cambiar la Música?", message:" La canción de fondo de la app cambiara a \(musicaArray[indexPath.row])", preferredStyle: .alert)
            alerta.setTitlet(font: UIFont(name:"DIN Alternate", size: 20), color: UIColor.black)
            alerta.setMessage(font: UIFont(name: "DIN Alternate", size: 18), color: UIColor.black)
        let accion = UIAlertAction(title: "Si", style: .default) { (accion) in
            reproductor.compartido.play(nombre: self.musicaArray[indexPath.row])
            self.escribirCancion(nuevoN: self.musicaArray[indexPath.row])
            self.labelEsta.text = "Esta sonando: \(self.canciones!.last!.cancionEscojida )"
        }
        let accionN = UIAlertAction(title: "No", style: .cancel) { (accionN) in
        
            }
        alerta.addAction(accion)
        alerta.addAction(accionN)
        present(alerta, animated: true , completion: nil)
        } else {
            let alertaN = UIAlertController(title: "Musica Detenida", message: "Activa la musica para seguir eschucando", preferredStyle: .actionSheet)
            if let popoverController = alertaN.popoverPresentationController {
              popoverController.sourceView = self.view
              popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
              popoverController.permittedArrowDirections = []
            }
            alertaN.setTitlet(font: UIFont(name: "DIN Alternate", size: 25), color: UIColor.black)
            alertaN.setMessage(font: UIFont(name: "DIN Alternate", size: 20), color: UIColor.black)
            let accionN = UIAlertAction(title: "Entendido", style: .default) { (accionN) in
            }
            alertaN.addAction(accionN)
            present(alertaN, animated: true, completion: nil)
        }

    }
    
    //MARK: Actions
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func deleteProjects(_ sender: Any) {
        if materias != nil {
            let alertaEliminar = UIAlertController(title: "¿Estas seguro de que quieres eliminar todas las materias?", message: "ESTO NO SE PUEDE REVERTIR", preferredStyle: .alert)
            alertaEliminar.setTitlet(font: UIFont(name:"DIN Alternate", size: 20), color: UIColor.black)
            alertaEliminar.setMessage(font: UIFont(name: "DIN Alternate", size: 18), color: UIColor.black)
            let deleteAction = UIAlertAction(title: "Eliminar", style: .destructive) { (action) in
                self.deleteAllProjects()
            }
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in }
            alertaEliminar.addAction(deleteAction)
            alertaEliminar.addAction(cancelAction)
            present(alertaEliminar, animated: true)
        } else {
            let alertaYaEliminada = UIAlertController(title: "No hay Materias", message: "No tienes Materias por el momento", preferredStyle: .alert)
            alertaYaEliminada.setTitlet(font: UIFont(name:"DIN Alternate", size: 20), color: UIColor.black)
            alertaYaEliminada.setMessage(font: UIFont(name: "DIN Alternate", size: 18), color: UIColor.black)
            let entendidoAccion = UIAlertAction(title: "Entendido", style: .cancel) { (action) in }
            alertaYaEliminada.addAction(entendidoAccion)
            present(alertaYaEliminada, animated: true)
        }
    }
    @IBAction func sliderAccion(_ sender: UISlider) {
        reproductor.compartido.cambiarVolumen(volumen: sliderVolumen.value)
            do {
                try realm.write {
                    canciones.last?.volumenR = sliderVolumen.value
                }
            } catch  {
                print(error)
            }

    }
    
    @IBAction func switchAccion(_ sender: UISwitch) {
        actualizarS()
    }
    
    
    //MARK: Methods

    
    
    func deleteAllProjects() {
        do {
            try realm.write {
                realm.delete(materias!)
            }
        } catch {
            print(error)
        }
    }
    func escribirCancion (nuevoN : String)  {
          do {
              try realm.write {
                  canciones.last?.cancionEscojida = nuevoN
              }
          } catch  {
              print(error)
          }
      }
    func cambiarEstado(estado : Bool)  {
           do {
               try realm.write {
                   canciones.last?.musicaED = estado
               }
           } catch  {
               print(error)
           }
       }
    func actualizarS()  {
        if switchEncender.isOn {
            labelEsta.text       = "Esta sonando: \(canciones.last?.cancionEscojida ?? "Mozart")"
            reproductor.compartido.play(nombre: canciones.last!.cancionEscojida)
            cambiarEstado(estado: false)
        } else {
            labelEsta.text       = "Musica detenida"
            reproductor.compartido.detener()
            cambiarEstado(estado: true)
            }
        }


    
}
