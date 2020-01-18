import UIKit
import RealmSwift

class MateriasCalendarioTVC: UITableViewController {
    
    //MARK: Properties
    
    let realm = try! Realm()
    var notasParaLaFechaSeleccionada : Results<Nota>?
    var formatter = DateFormatter()

    //MARK: Set Up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarF(color: "#3D81AD")
        formatter.dateStyle = .full
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCalendarProjectsTableView), name: NSNotification.Name(rawValue: "reloadCalendarTableView"), object: nil)
        notasParaLaFechaSeleccionada = realm.objects(Nota.self).filter("fecha == %@", fechaCalendario ?? formatter.string(from: Date())).sorted(byKeyPath: "nota")

        title = fechaCalendario ?? formatter.string(from: Date())
    }

    
    override func viewWillAppear(_ animated: Bool) {
        if notasParaLaFechaSeleccionada!.count == 0 {
            let sinNotasPorFechaAlert = UIAlertController(title: "No hay notas para la fecha seleccionada", message: "primero crea una" , preferredStyle: .alert)
            let entendidoAction = UIAlertAction(title: "entendido", style: .default) { (action) in
               
            }
            sinNotasPorFechaAlert.addAction(entendidoAction)
            self.present(sinNotasPorFechaAlert, animated: true)
        } else {
                    print(notasParaLaFechaSeleccionada!.first!.nota)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return notasParaLaFechaSeleccionada!.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ProjectTableViewCell()
            cell.textLabel?.text = notasParaLaFechaSeleccionada![indexPath.row].nota
        cell.detailTextLabel?.text = notasParaLaFechaSeleccionada![indexPath.row].materiaPadre[indexPath.row].nombreMateria
        cell.textLabel?.font = UIFont(name: "DIN Alternate", size: 18)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
  
    //MARK: Methods
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if notasParaLaFechaSeleccionada?.count != 0  {
            let delete = eliminarNota(at: indexPath)
            let edit   = editarNota(at: indexPath)
            return UISwipeActionsConfiguration(actions: [delete, edit])
        } else {
            return nil
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
    
    func eliminarNota(at indexPath : IndexPath) -> UIContextualAction {
        let eliminarAction = UIContextualAction(style: .normal, title: "Eliminar") { (contextualAction, view, boolValue) in
            boolValue(true)
            let eliminarAlert = UIAlertController(title: "seguro que quieres eliminar esta nota", message: "aviso: esto no puede ser desecho", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Eliminar", style: .destructive) { (action) in
                self.eliminarMateriasDelRealm(whatToDelete: self.notasParaLaFechaSeleccionada![indexPath.row])
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.notasParaLaFechaSeleccionada = self.realm.objects(Nota.self).filter("fecha == %@", fechaCalendario!).sorted(byKeyPath: "nota")
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
    
    
    func editarNota(at indexPath : IndexPath) -> UIContextualAction {
        let editarAction = UIContextualAction(style: .normal, title: "Editar") { (contextualAction, view, boolValue) in
            boolValue(true)
            notaParaEditar = self.notasParaLaFechaSeleccionada![indexPath.row]
            segueFuente = 1
            crear = false
            self.performSegue(withIdentifier: "toNewProject", sender: self)
            
        }
        editarAction.backgroundColor = .gray
        return editarAction
    }
    
        
    func eliminarMateriasDelRealm(whatToDelete: Nota) {
        do {
            try self.realm.write {
                self.realm.delete(whatToDelete)
            }
        } catch{
            print(error)
        }
    }

    
    @objc func reloadCalendarProjectsTableView() {
        tableView.reloadData()
    }
}

