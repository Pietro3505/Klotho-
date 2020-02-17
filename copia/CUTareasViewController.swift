//
//  CUTareasViewController.swift
//  Calendario+
//
//  Created by Pablo y Pietro on 1/12/20.
//  Copyright © 2020 Pablo Jarrin. All rights reserved.
//

import UIKit

var  materiaTarea = 0


class CUTareasViewController: UIViewController, UINavigationBarDelegate {
    
    var hora : DateComponents?
    var fechaEntrega : Date?
    var horaEntrega : String = ""
    let formatter = DateFormatter()
    
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet var nombreTareaTF: UITextField!
    @IBOutlet var detallesTareaTF: UITextField!
    @IBOutlet var materiaSC: UISegmentedControl!
    @IBOutlet weak var boton: UIButton!
    @IBOutlet weak var datePickerO: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nombreTareaTF.text = ""
        nombreTareaTF.isEnabled = true
        formatter.dateStyle = .full
        if segueSource == 0 {
            boton.titleLabel?.text = "Crear Tarea"
            nombreTareaTF.text = ""
            nombreTareaTF.isEnabled = true
            segueSource = nil
        } else if segueSource == 1{
            boton.titleLabel?.text = "Editar Tarea"
            nombreTareaTF.text = "\(tareaParaEditar!.documentID)"
            nombreTareaTF.isEnabled = false
            segueSource = nil
        }
        fechaEntrega = datePickerO.date
        hora = Calendar.current.dateComponents([.hour, .minute], from: datePickerO.date )
        if hora!.minute! < 10 {
            horaEntrega = "\(hora!.hour!):0\(hora!.minute!)"
        } else {
            horaEntrega = "\(hora!.hour!):\(hora!.minute!)"

        }
    }


    @IBAction func datePicker(_ sender: UIDatePicker) {
        fechaEntrega = datePickerO.date
        hora = Calendar.current.dateComponents([.hour, .minute], from: datePickerO.date )
        if hora!.minute! < 10 {
            horaEntrega = "\(hora!.hour!):0\(hora!.minute!)"
        } else {
            horaEntrega = "\(hora!.hour!):\(hora!.minute!)"

        }
    }
    
    
    
    
    @IBAction func materiaSCAction(_ sender: UISegmentedControl) {
        switch materiaSC.selectedSegmentIndex {
        case 0:
            materiaTarea = 0
        case 1:
            materiaTarea = 1
        case 2:
            materiaTarea = 2
        case 3:
            materiaTarea = 3
        case 4:
            materiaTarea = 4
        default:
                break
        }
        print("yeahh")
    }
    
    @IBAction func crearOEditar(_ sender: UIButton) {
        if nombreTareaTF.text == "" || detallesTareaTF.text == ""  {
            let alert =  UIAlertController(title: "Te falta algo" , message: "Neceseitas llenar todos los campos y seleccionar materia primero", preferredStyle: .alert)
            let entendidoAction = UIAlertAction(title: "Entendido", style: .cancel)
            alert.addAction(entendidoAction)
            present(alert, animated: true, completion: nil)
        } else {
            datePickerO.endEditing(true)
            BaseDeDatos.shared.crearOEditarTarea(nombre: nombreTareaTF.text!, detalles: detallesTareaTF.text!, materia: materiaTarea, fechaEntrega: formatter.string(from: fechaEntrega!), horaEntrega: horaEntrega)
            self.dismiss(animated: true)
        }
    }
    
}
