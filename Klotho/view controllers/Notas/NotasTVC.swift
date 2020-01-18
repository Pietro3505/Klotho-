import UIKit
import RealmSwift

 

class NotasTVC: UITableViewController {

    let realm = try! Realm()
    var actividades : Results<Nota>?
    var seleccionarOCrearProyecto : String?
        
    //MARK: Outlets
    
    @IBOutlet var ActivitiesTableView: UITableView!
    
    //MARK: Set Up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarF(color: "#3D81AD")
        if  materiaSeleccionada == nil {
            setBlankView()
        }
        else {
            cambiarTitulo()
            loadActivities()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(loadActivities), name: NSNotification.Name(rawValue: "loadActivities"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadActivities), name: NSNotification.Name(rawValue: "reloadActivities"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cambiarTitulo), name: NSNotification.Name(rawValue: "setTitle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setBlankView), name: NSNotification.Name(rawValue: "setBlankTitle"), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }


    //MARK: TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if materiaSeleccionada != nil{
            return actividades?.count ?? 0
        } else {
            return 0
        }
            
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activityCell = ActivityTableViewCell()
        activityCell.textLabel?.text = actividades?[indexPath.row].nota
        activityCell.detailTextLabel?.text = actividades?[indexPath.row].detalles
        activityCell.textLabel?.font = UIFont(name: "DIN Alternate", size: 18)
        if actividades?[indexPath.row].completo == true {
            activityCell.accessoryType = .checkmark
        }
        else {
            activityCell.accessoryType = .none
        }
        return activityCell
    }
    
    
    //MARK: Acciones
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toActivityDetailedView" {
            let detailsVC = segue.destination as! DetallesNotaVC
            let indexPath = tableView.indexPathForSelectedRow!
            detailsVC.actividadDetallada = actividades?[indexPath.row]
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toActivityDetailedView", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func goToNewActivitiesVC(_ sender: UIBarButtonItem) {
        if materias?.count == 0 {
            seleccionarOCrearProyecto = "añadido"
        }
        else {
            seleccionarOCrearProyecto = "seleccionado"
        }
        
        if materiaSeleccionada != nil {
            segueFuente = 1
            crear = true
            performSegue(withIdentifier: "editOrCreateActivity", sender: self)
        } else {
            let selectProjectFirstAlert = UIAlertController(title: "Parece que falta algo", message: "no has \(seleccionarOCrearProyecto!) una materia todavia", preferredStyle: .alert)
            let understoodAction = UIAlertAction(title: "entendido", style: .cancel) { (action) in
            }
            selectProjectFirstAlert.addAction(understoodAction)
            self.present(selectProjectFirstAlert, animated: true, completion: nil)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = eliminarActividad(at: indexPath)
        let edit = editarActividad(at:indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    

    //MARK: Methodos
    
    
    func eliminarActividad(at indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .normal, title: "Eliminar") { (contextualAction, view, boolValue) in
            boolValue(true)
            let deleteAlert = UIAlertController(title: "Segur@ quieres eliminar esta nota", message: "note: This can`t be undone", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Eliminar", style: .destructive) { (action) in
                self.eliminarActividadDelRealm(activity: (self.actividades?[indexPath.row])!)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.reloadData()
            }
            let doNotDeleteAction = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
            }
            deleteAlert.addAction(action)
            deleteAlert.addAction(doNotDeleteAction)
            self.present(deleteAlert, animated: true, completion: nil)
        }
        deleteAction.backgroundColor = .red
        return deleteAction
    }
    
    func editarActividad(at indexPath:IndexPath) -> UIContextualAction {
        let accionEditar = UIContextualAction(style: .normal, title: "Editar") { (contextualAction, view, boolValue) in
            boolValue(true)
            segueFuente = 1
            crear = false
            notaParaEditar = self.actividades?[indexPath.row]
            self.performSegue(withIdentifier: "editOrCreateActivity", sender: self)
        
        }
        accionEditar.backgroundColor = .gray
        return accionEditar
    }
    
    
    func eliminarActividadDelRealm(activity: Nota) {
        do {
            try realm.write {
                realm.delete(activity)
            }
        } catch {
            print("\(error)")
        }
    }
    
    
    
    @objc func cambiarTitulo() {
        title = "Notas \(materiaSeleccionada!.nombreMateria)"
    }
    
    
    @objc func setBlankView() {
        if materias?.count != 0{
            title = "seleccciona una materia primero"
        }
        else {
            title = "añade una materia primero"
        }
        tableView.separatorStyle = .none
    }
    
    
    @objc func loadActivities() {
            actividades = materiaSeleccionada!.notas.sorted(byKeyPath: "nota", ascending: true)
            tableView.reloadData()
    }
    
    
    @objc func reloadActivities() {
        tableView.reloadData()
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

