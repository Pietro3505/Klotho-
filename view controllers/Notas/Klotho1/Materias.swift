import RealmSwift
import UIKit
import Firebase



var editarMateria : Bool?
var materiass : [QueryDocumentSnapshot] = []
var materiaSelected : String?
var nombreMateria : String?

class Materias: UITableViewController , UISearchBarDelegate {
    
    var imagenResults : Results<NumeroDeImagenes>!
    let realm = try! Realm()
    var permiso : Int = 0
    var imagenesDescargadas = [String : UIImage?]()
    var listo : Bool =  false

    @IBOutlet weak var materiasSearchBar: UISearchBar!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
         imagenResults = realm.objects(NumeroDeImagenes.self)
        addSnapshotListener()
        crear = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
 
    @IBAction func nuevaMateria(_ sender: UIBarButtonItem) {

    }
    
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materiass.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let materia = materiass[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FIRMateriasTableVIewCell", for: indexPath) as! MateriaTableViewCell
        cell.materiaTextLabel.text = "\(materia.get("materia")!)"
        cell.nombreProfesorTextLabel.text = "\(materia.get("profesor")!)"
        
        if  permiso == imagenResults.count {
          
            if imagenesDescargadas.count != 0 {
                let url = materia.get("imagen")!
                let imagenIndex = imagenesDescargadas["\(url)"]
                print(materia.get("imagen")!)
                
                cell.materiaImageView.image = imagenIndex!
                print("hecho")
                
            }
            
               } else {
            if listo == false {
                let url = materia.get("imagen")!
                print("esta es \(url)")
            
                descargarImg(lugar: "\(url)")
                cell.materiaImageView.image = UIImage.init(named: "Klotho")
            }
            }
        
    
        
        
            return cell
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "tareasPreguntasTableView", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        materiaSelected = "\(materiass[indexPath.row].documentID)"
        nombreMateria =  "\(materiass[indexPath.row].get("materia")!)"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if notasParaLaFechaSeleccionada?.count != 0  {
            let delete = eliminarMateria(at: indexPath)
            let edit   = editarMateria(at: indexPath)
            return UISwipeActionsConfiguration(actions: [delete, edit])
        } else {
            return nil
        }
    }
    
    

    // MARK: -Methods
 
    
    func eliminarMateria(at indexPath : IndexPath) -> UIContextualAction {
        let eliminarAction = UIContextualAction(style: .normal, title: "Eliminar") { (contextualAction, view, boolValue) in
            boolValue(true)
            let eliminarAlert = UIAlertController(title: "seguro que quieres eliminar esta nota", message: "aviso: esto no puede ser desecho", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Eliminar", style: .destructive) { (action) in
                materiasReferecne.document("\(materiass[indexPath.row].documentID)").delete()
                materiaSelected = nil
                self.performSegue(withIdentifier: "tareasPreguntasTableView", sender: self)
                self.tableView.reloadData()
            }
            let cancelarAction = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
            }
            eliminarAlert.addAction(action)
            eliminarAlert.addAction(cancelarAction)
            self.present(eliminarAlert, animated: true, completion: nil)
        }
        eliminarAction.backgroundColor = .red
        return eliminarAction
    }
    
    
    func editarMateria(at indexPath : IndexPath) -> UIContextualAction {
        let editarAction = UIContextualAction(style: .normal, title: "Editar") { (contextualAction, view, boolValue) in
            boolValue(true)
            materiaSelected = "\(materiass[indexPath.row].documentID)"
            crear = false
            self.performSegue(withIdentifier: "CUMateriaSegue", sender: self)
            
        }
        editarAction.backgroundColor = .gray
        return editarAction
    }


    
    func addSnapshotListener() {
        materiasReferecne.addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error retreiving collection: \(error)")
            }
            materiass.removeAll()
            for document in querySnapshot!.documents {
                print("\(document.documentID)")
                materiass.append(document)
                print(materiass.count)
            }
            documentCount = materiass.count
            print("numero de taeras: \(documentCount!)")
            self.tableView.reloadData()
        }
    }
    
    
    func descargarImg (lugar : String)  {
        
        let imagenRef = almacenamientoEnNube.reference().child("\(lugar)")
        let downloadTask = imagenRef.getData(maxSize: (1 * 1024 * 1024)) { (data, error) in
          if let error = error {
            
             print("error Aiuda \(error.localizedDescription)")
            
          
           } else {
             if let data = data {
           let myImage : UIImage! = UIImage(data: data)
                   if self.permiso != self.imagenResults.count  {
                    self.imagenesDescargadas[lugar] = myImage
                    
                    self.permiso = self.imagenesDescargadas.count
                    print(self.permiso)
                    print(lugar)
                    print(self.imagenResults.count)
                    self.tableView.reloadData()
                    self.listo = true
                    print(self.imagenesDescargadas.description)
                }
                   
                
              }
            }
           }
              let observer = downloadTask.observe(.success) { snapshot in
                   if self.permiso == self.imagenResults.count {
                    
                    self.tableView.reloadData()
                     print("memin")
                        }
                }
    
    }
    
  
    // MARK: -Search Bar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        filterForSearchBar(data: searchBar.text!)
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            searchBar.resignFirstResponder()
            searchBar.showsCancelButton = false
            fillDocumentsBack()
            tableView.reloadData()
        } else {
            tableView.reloadData()
            searchBar.showsCancelButton = true
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        fillDocumentsBack()
        tableView.reloadData()
    }

    
    
    func filterForSearchBar(data: String) {
        materiasReferecne.whereField("materia", isEqualTo: data).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error retreiving collection: \(error)")
            }
            materiass.removeAll()
            for document in querySnapshot!.documents {
                print("\(document.documentID)")
                materiass.append(document)
                print(materiass.count)
            }
            documentCount = materiass.count
            print("numero de taeras: \(documentCount!)")
            self.tableView.reloadData()
        }
    }
    
    func fillDocumentsBack() {
        materiasReferecne.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error retreiving collection: \(error)")
            }
            materiass.removeAll()
            for document in querySnapshot!.documents {
                print("\(document.documentID)")
                materiass.append(document)
                print(materiass.count)
            }
            documentCount = materiass.count
            print("numero de taeras: \(documentCount!)")
            self.tableView.reloadData()
        }
    }
    
    
}

    // MARK: - Materia Table View Cell

class MateriaTableViewCell : UITableViewCell {
    @IBOutlet weak var materiaTextLabel: UILabel!
    @IBOutlet weak var nombreProfesorTextLabel: UILabel!
    @IBOutlet weak var materiaImageView: UIImageView!
    
    
}
