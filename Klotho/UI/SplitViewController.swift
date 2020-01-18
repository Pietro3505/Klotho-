import UIKit

class SplitViewController: UISplitViewController,
UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        self.delegate             = self
        self.preferredDisplayMode = .allVisible
    }
    
    func splitViewController( _ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}
