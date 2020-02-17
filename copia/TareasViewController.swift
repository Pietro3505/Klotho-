//
//  ViewController.swift
//  Calendario+
//
//  Created by Pablo y Pietro on 1/10/20.
//  Copyright © 2020 Pablo Jarrin. All rights reserved.
//

import UIKit
import Firebase
import FSCalendar

var actualizar = false
var segueSource : Int?
var documentCount  :  Int?
var documentss :[QueryDocumentSnapshot] = []
var tareaParaEditar : QueryDocumentSnapshot?

class TareasViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate,  UITableViewDataSource {
    
    

    
    @IBOutlet weak var calendar: FSCalendar!
    

    
    var db = gdb.collection("Tareas")
    let formatter = DateFormatter()
    
    @IBOutlet weak var tabla: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateStyle      = .full
        actualizar = true
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name(rawValue: "reload"), object: nil)
        db.whereField("fechaEntrega", isEqualTo: formatter.string(from: Date.init())).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error retreiving collection: \(error)")
            }
            documentss.removeAll()
            for document in querySnapshot!.documents {
                print("\(document.documentID)")
                documentss.append(document)
                print(documentss.count)
            }
            documentCount = documentss.count
            print("numero de taeras: \(documentCount!)")
            self.tabla.reloadData()
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if date != Date.init() {
            db.whereField("fechaEntrega", isEqualTo: formatter.string(from: date)).addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error retreiving collection: \(error)")
                }
                documentss.removeAll()
                for document in querySnapshot!.documents {
                    print("\(document.documentID)")
                    documentss.append(document)
                    print(documentss.count)
                }
                documentCount = documentss.count
                print("numero de taeras: \(documentCount!)")
                self.tabla.reloadData()
            }
        }
    }
        
    
    @IBAction func goCreate(_ sender: UIBarButtonItem) {
        segueSource = 0
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return documentCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "tareaCell", for: indexPath) as! TareasTableViewCell
        let  document = documentss[indexPath.row]
        var materia = ""
        var imagen = ""
        if document.get("materia") as! Int == 0 {
            materia = "Matemáticas"
            imagen = "matematicas"
        } else if document.get("materia") as! Int == 1 {
            materia = "Literatura"
            imagen = "literatura"
        } else if document.get("materia") as! Int == 2 {
            materia = "Language"
            imagen = "language"
        } else if document.get("materia") as! Int == 3 {
            materia = "Science"
            imagen = "ciencia"
        } else if document.get("materia") as! Int == 4 {
            materia = "Ind. and Societies"
            imagen = "historia"
        }
        cell.materiaTextLabel.text = materia
        cell.fechaEntregaTextLabel.text = "Entrega: \(document.get("horaEntrega")!)"
        cell.nombreTareaTextLabel.text = "\(document.documentID)"
       // cell.materiaImageView.image = UIImage(imageLiteralResourceName: imagen)
        
        return cell
    }
    
    
    @objc func reload() {
        tabla.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  document = documentss[indexPath.row]
        let selectProjectFirstAlert = UIAlertController(title: "Detalles de la tarea", message:  "\(document.get("detalles")!)", preferredStyle: .alert)
        let understoodAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
        }
        selectProjectFirstAlert.addAction(understoodAction)
        self.present(selectProjectFirstAlert, animated: true, completion: nil)
        tabla.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = eliminarTarea(at: indexPath)
        let edit = editarTarea(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func eliminarTarea(at indexPath: IndexPath) -> UIContextualAction {
        let deleteAction = UIContextualAction(style: .normal, title: "Eliminar") { (contextualAction, view, boolValue) in
            boolValue(true)
            let deleteAlert = UIAlertController(title: "¿Seguro quieres eliminar esta tarea?", message: "aviso: esto no se puede deshacer", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Eliminar", style: .destructive) { (action) in
                BaseDeDatos.shared.eliminar(document: documentss[indexPath.row])
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
    
    func editarTarea(at indexpath: IndexPath) -> UIContextualAction {
        let editAction = UIContextualAction(style: .normal, title: "Editar") { (contextualAction, view, boolValue) in
        boolValue(true)
            segueSource = 1
            tareaParaEditar = documentss[indexpath.row]
            self.performSegue(withIdentifier: "crearOEditar", sender: self)
        }
        editAction.backgroundColor = .gray
        return editAction
    }
    
    

}

class TareasTableViewCell: UITableViewCell {
    
    @IBOutlet weak var materiaTextLabel: UILabel!
    @IBOutlet weak var nombreTareaTextLabel: UILabel!
    @IBOutlet weak var fechaEntregaTextLabel: UILabel!
    @IBOutlet weak var materiaImageView: UIImageView!
    
}
