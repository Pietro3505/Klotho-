import GoogleSignIn
import FirebaseAuth
import Firebase
import UIKit

class InicioDeSesionVC: UIViewController, GIDSignInDelegate {

    @IBOutlet weak var signInButton: GIDSignInButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    Auth.auth().addStateDidChangeListener { (auth, user) in
        if Auth.auth().currentUser != nil {
            print("efe")
            
        } else {
          // No user is signed in.
          // ...
        }
        }
        
    }
 
    @IBAction func signInButtonAction(_ sender: UIButton) {
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {

    if let error = error {
      print(error)
      return
    }
    guard let authentication = user.authentication else { return }
    let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                      accessToken: authentication.accessToken)
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if let error = error {
          print(error)
          return
        }
      }
     
  }
  
  
  
  func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
  }
  
}
