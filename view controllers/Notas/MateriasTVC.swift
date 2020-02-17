import UIKit
import RealmSwift



class MateriasTVC: UITableViewController {
    

    //MARK: Properties
    let realm  = try! Realm()

    
    //MARK: Outlet
    @IBOutlet weak var searchBar: UISearchBar!

    //MARK: Set Up
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarF(color: "#000000")
        materias = realm.objects(Materia.self).sorted(byKeyPath: "importanciaMateria", ascending: false)
        cargarMaterias()
        searchBar.showsCancelButton = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(reladMateriasTableView), name: NSNotification.Name(rawValue: "reloadProjectsTableView"), object: nil)
        personalizacion(color: "#000000")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = true
    }

     
    
    // MARK: - Table view data source
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return materias?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProjectTableViewCell()
        cell.textLabel?.text = materias?[indexPath.row].nombreMateria
        cell.textLabel?.font = UIFont(name: "DIN Alternate", size: 18)
        cell.detailTextLabel?.text = "\(materias?[indexPath.row].nombreProfesor ?? "") \(materias?[indexPath.row].importanciaMateria ?? "")"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        materiaSeleccionada = materias?[indexPath.row]
        performSegue(withIdentifier: "showActivities", sender: self)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadActivities"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setTitle"), object: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
      
    
      
    
    

    
    //MARK: Actions
    @IBAction func dismissProjectsView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        materiaSeleccionada = nil
    }
    @IBAction func createNewProjectAction(_ sender: UIBarButtonItem) {
        segueFuente = 0
        crear = true
        performSegue(withIdentifier: "editOrCreateProject", sender: self)
    }
    

    
    //MARK: - Methods
    func personalizacion(color : String){
          searchBar.barTintColor = UIColor("\(color)")
        let cancelButton = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont(name: "DIN Alternate", size: 20)]
          UIBarButtonItem.appearance().setTitleTextAttributes(cancelButton as [NSAttributedString.Key : Any] , for: .normal)
          let textFS = searchBar.value(forKey: "searchField") as? UITextField
          textFS?.font = UIFont(name: "DIN Alternate", size: 20)
          textFS?.textColor = UIColor.white
          textFS?.backgroundColor = UIColor("#000000")
      }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteProject(at: indexPath)
        let edit = editarMateria(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func deleteProject(at indexPath : IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete!") { (contextualAction, view, boolValue) in
            boolValue(true)
            let deleteAlert = UIAlertController(title: "Segur@ quieres eliminar esta materia", message: "aviso: esto no puede ser deshecho", preferredStyle: .alert)
            let action = UIAlertAction(title: "Eliminar", style: .destructive) { (action) in
                self.eliminarMateriaDeRealm(queEliminar: (materias?[indexPath.row])!)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                materias = self.realm.objects(Materia.self)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadActivities"), object: nil)
                self.tableView.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setBlankTitle"), object: nil)
                self.tableView.reloadData()
            }
            
            let doNotDeleteAction = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
                self.tableView.reloadData()
            }
            deleteAlert.addAction(action)
            deleteAlert.addAction(doNotDeleteAction)
            self.present(deleteAlert, animated: true, completion: nil)
        }
        deleteAction.backgroundColor = .red
        return deleteAction
    }
    
    
    func editarMateria(at indexPath : IndexPath) -> UIContextualAction {
        let editAction = UIContextualAction(style: .normal, title: "Editar") { (contextualAction, view, boolValue) in
            boolValue(true)
            materiaSeleccionada = materias?[indexPath.row]
            segueFuente = 0
            crear = false
            self.performSegue(withIdentifier: "editOrCreateProject", sender: self)
        }
        editAction.backgroundColor = .gray
        return editAction
    }
    
    func cargarMaterias(){
        materias = realm.objects(Materia.self)
    }
    
    @objc func reladMateriasTableView() {
        tableView.reloadData()
    }
    
    func eliminarMateriaDeRealm(queEliminar: Materia) {
        do {
            try self.realm.write {
                self.realm.delete(queEliminar.notas)
                self.realm.delete(queEliminar)
            }
        } catch{
            print("\(error)")
        }
    }
    func navBarF (color : String) {
       guard let navBar       = navigationController?.navigationBar else {fatalError("Navigation controller no existe")}
       guard let navBarColour = UIColor("#000000") else { fatalError()}
       navBar.barTintColor    = navBarColour
       navBar.tintColor       = UIColor.white
       let textAttributes     = [NSAttributedString.Key.font : UIFont(name: "DIN Alternate", size: 18), NSAttributedString.Key.foregroundColor:UIColor.white]
       let textAttributes1    = [NSAttributedString.Key.font : UIFont(name: "DIN Alternate", size: 50), NSAttributedString.Key.foregroundColor:UIColor.white]
       navBar.titleTextAttributes      = textAttributes as [NSAttributedString.Key : Any]
       navBar.largeTitleTextAttributes = textAttributes1 as [NSAttributedString.Key : Any]
         }



}

//MARK: Search Bar

extension MateriasTVC : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        materias = realm.objects(Materia.self).filter("nombreMateria CONTAINS [cd]%@", searchBar.text!).sorted(byKeyPath: "importanciaMateria", ascending: true)
        tableView.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            searchBar.resignFirstResponder()
            searchBar.showsCancelButton = false
            materias = realm.objects(Materia.self)
            tableView.reloadData()
        } else {
            materias = realm.objects(Materia.self).filter("nombreMateria CONTAINS [cd]%@", searchBar.text!).sorted(byKeyPath: "importanciaMateria", ascending: true)
            tableView.reloadData()
            searchBar.showsCancelButton = true
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        materias = realm.objects(Materia.self)
        tableView.reloadData()
    }
    @objc func reloadProjectsTableView() {
          tableView.reloadData()
      }
    
}

