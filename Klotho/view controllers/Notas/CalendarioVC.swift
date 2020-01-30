import UIKit
import FSCalendar
import RealmSwift

class CalendarioVC: UIViewController {

    let formatter = DateFormatter()
    fileprivate weak var calendar: FSCalendar!
    let realm = try! Realm()

    //MARK: Set Up
    
    override func viewDidLoad() {
        navBarF(color: "#3D81AD")
        super.viewDidLoad()
        formatter.dateStyle      = .full
        let calendar             = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 646))
        calendar.dataSource      = self
        calendar.delegate        = self
        self.calendar            = calendar
        calendar.backgroundColor = .lightGray
        view.addSubview(calendar)
        constrainsCalendario()
        fechaCalendario = formatter.string(from: Date.init())
    }
    
    
    //MARK: Button
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Methods
    
  }


//MARK: Calendar

extension CalendarioVC : FSCalendarDelegate, FSCalendarDataSource {
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        fechaCalendario = formatter.string(from: date)
        notasParaLaFechaSeleccionada = realm.objects(Nota.self).filter("fecha CONTAINS [cd]%@", fechaCalendario!).sorted(byKeyPath: "fecha", ascending: true)
        performSegue(withIdentifier: "showProjectsForDate", sender: self)
    }
  
    
    func constrainsCalendario() {
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        calendar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        calendar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        calendar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
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




