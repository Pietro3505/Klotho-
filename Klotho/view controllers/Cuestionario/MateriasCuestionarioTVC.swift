//
//  MateriasCuestionarioTVC.swift
//  Klotho
//
//  Created by Pablo y Pietro on 1/28/20.
//  Copyright © 2020 Pietro Pablo Producciones. All rights reserved.
//

import UIKit
import RealmSwift

class MateriasCuestionarioTVC: UITableViewController {
    let realm = try! Realm()
    
    
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Table view data source

    //MARK: Set Up
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarF(color: "#000000")
        personalizacion(color: "#000000")
        materias = realm.objects(Materia.self).sorted(byKeyPath: "importanciaMateria", ascending: false)
        loadProjects()
        searchBar.showsCancelButton = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(reladMateriasTableView), name: NSNotification.Name(rawValue: "reladMateriasTableView"), object: nil)
        
        
        
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
        cell.detailTextLabel?.text =  "\(materias?[indexPath.row].nombreProfesor ?? "") \(materias?[indexPath.row].importanciaMateria ?? "")"
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        materiaSeleccionada = materias?[indexPath.row]
        performSegue(withIdentifier: "MostrarPreguntas", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func personalizacion(color : String){
        searchBar.barTintColor = UIColor("\(color)")
        let cancelButton = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont(name: "DIN Alternate", size: 20)]
          UIBarButtonItem.appearance().setTitleTextAttributes(cancelButton as [NSAttributedString.Key : Any] , for: .normal)
        let textFS = searchBar.value(forKey: "searchField") as? UITextField
        textFS?.font = UIFont(name: "DIN Alternate", size: 20)
        textFS?.textColor = UIColor.white
        textFS?.backgroundColor = UIColor("#000000")
          
      }
    
    
    
    
    
    //MARK: Actions

    @IBAction func createNewProjectAction(_ sender: UIBarButtonItem) {
        segueFuente = 0
        crear = true
        performSegue(withIdentifier: "CrearMaterias", sender: self)
    }
    
    @IBAction func dismissPantallaMaterias(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
        materiaSeleccionada = nil
    }
    
    
    
    //MARK: - Methods
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteProject(at: indexPath)
        let edit = editProject(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func deleteProject(at indexPath : IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .normal, title: "Eliminar!") { (contextualAction, view, boolValue) in
            boolValue(true)
            let deleteAlert = UIAlertController(title: "segur@ quieres eliminar esta materia", message: "aviso: esto no puede ser deshecho", preferredStyle: .alert)
            let action = UIAlertAction(title: "Eliminar", style: .destructive) { (action) in
                self.deleteProjectFromRealm(whatToDelete: (materias?[indexPath.row])!)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                materias = self.realm.objects(Materia.self)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadActivities"), object: nil)
                self.tableView.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setBlankTitle"), object: nil)
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
    
    
    func editProject(at indexPath : IndexPath) -> UIContextualAction {
        let editAction = UIContextualAction(style: .normal, title: "Editar") { (contextualAction, view, boolValue) in
            boolValue(true)
            materiaSeleccionada = materias?[indexPath.row]
            segueFuente = 0
            crear = false
            self.performSegue(withIdentifier: "CrearMaterias", sender: self)
        }
        editAction.backgroundColor = .gray
        return editAction
    }
    
    func loadProjects(){
        materias = realm.objects(Materia.self)
    }
    
    @objc func reladMateriasTableView() {
        tableView.reloadData()
    }
    
    func deleteProjectFromRealm(whatToDelete: Materia) {
        do {
            try self.realm.write {
                self.realm.delete(whatToDelete.notas)
                self.realm.delete(whatToDelete)
            }
        } catch{
            print("\(error)")
        }
    }
    
    
    
    
}

//MARK: Search Bar

extension MateriasCuestionarioTVC : UISearchBarDelegate {
    
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
