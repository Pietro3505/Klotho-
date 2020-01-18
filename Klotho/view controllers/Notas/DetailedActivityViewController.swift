
import UIKit
import RealmSwift

class DetailedActivityViewController: UIViewController {
    
    let realm = try! Realm()
    var detailedActivity : Nota?
    let formatter = DateFormatter()

    @IBOutlet weak var containingDetailView: UIView!
    @IBOutlet weak var activityDetails: UILabel!
    @IBOutlet weak var realizationDateLabel: UILabel!
    @IBOutlet weak var setDoneStatusFromActivityOutlet: UISegmentedControl!
    @IBOutlet weak var deleteActivityOutlet: UIButton!
    @IBOutlet weak var viewContainingDoneStatusView: UIView!
    @IBOutlet weak var markAsCompletedLabel: UILabel!
    @IBOutlet weak var detailsTitle: UILabel!
    @IBOutlet weak var alertDateTitle: UILabel!
    
    @IBOutlet weak var viewContainigAlertDate: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = detailedActivity?.nota
        activityDetails.text      = detailedActivity?.detalles
        formatter.dateStyle       = .full
        formatter.timeStyle       = .short
        realizationDateLabel.text = detailedActivity!.fecha
        setSegmentedControl()
        if detailedActivity?.detalles == "" {
            containingDetailView.isHidden = true
        }
    } 
    
    
    @IBAction func deleteActivityButton(_ sender: UIButton) {
        do {
            try realm.write {
                realm.delete(detailedActivity!)
            }
        } catch {
            print("te vieron las huevas \(error)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func setDoneStatusFromActivity(_ sender: Any) {
        switch setDoneStatusFromActivityOutlet.selectedSegmentIndex {
        case 0:
            setDoneStatus(status: false)
        case 1:
            setDoneStatus(status: true)
        default:
         break
        }
    }
    
    
    func setDoneStatus(status: Bool){
        do {
            try realm.write {
                detailedActivity?.completo = status
            }
        } catch {
            print(error)
        }
    }
    
    
    func setSegmentedControl() {
        if detailedActivity?.completo == true {
            setDoneStatusFromActivityOutlet.selectedSegmentIndex = 1
        } else {
            setDoneStatusFromActivityOutlet.selectedSegmentIndex = 0
        }
    }
    
    
}
