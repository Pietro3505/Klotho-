import FirebaseStorage
import RealmSwift
import Firebase
import UIKit

class CUMateriaViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var urlScope      : URL?
    var urlImagenNube : String?
    var imagenScope   : UIImage?
    var imagenResults : Results<NumeroDeImagenes>!
    let realm = try! Realm()
    var pickerControllerVariable : UIImagePickerController!
    
    
    
    @IBOutlet weak var boton: BotonP!
    
    @IBAction func sleccionarImagen(_ sender: UIButton) {
        let ActionSheet = UIAlertController(title: nil, message: "Select Photo", preferredStyle: .actionSheet)

          let cameraPhoto = UIAlertAction(title: "Camera", style: .default, handler: {
              (alert: UIAlertAction) -> Void in
              if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){

                self.pickerControllerVariable.mediaTypes = ["public.image"]
                self.pickerControllerVariable.sourceType = UIImagePickerController.SourceType.camera;
                self.present(self.pickerControllerVariable, animated: true, completion: nil)
              }
              else{
                  UIAlertController(title: "iOSDevCenter", message: "No Camera available.", preferredStyle: .alert).show(self, sender: nil);
              }

          })

          let PhotoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: {
              (alert: UIAlertAction) -> Void in
              if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                self.pickerControllerVariable.mediaTypes = ["public.image"]
                self.pickerControllerVariable.sourceType = UIImagePickerController.SourceType.photoLibrary;
                self.present(self.pickerControllerVariable, animated: true, completion: nil)
              }

          })

          let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
              (alert: UIAlertAction) -> Void in

          })

          ActionSheet.addAction(cameraPhoto)
          ActionSheet.addAction(PhotoLibrary)
          ActionSheet.addAction(cancelAction)


          if UIDevice.current.userInterfaceIdiom == .pad{
              let presentC : UIPopoverPresentationController  = ActionSheet.popoverPresentationController!
              presentC.sourceView = self.view
              presentC.sourceRect = self.view.bounds
              self.present(ActionSheet, animated: true, completion: nil)
          }
          else{
              self.present(ActionSheet, animated: true, completion: nil)
          }
        
//        let imagen = UIImagePickerController()
//               imagen.delegate = self
//               imagen.sourceType = UIImagePickerController.SourceType.photoLibrary
//               imagen.allowsEditing = false
//               self.present(imagen, animated: true)
//               {
//
//               }
    }
    @IBOutlet weak var didSelectImage: UIImageView!
    @IBOutlet weak var imgSeleccionada: UIImageView!
    @IBOutlet weak var profesor: UITextField!
    @IBOutlet weak var nombreMateriaTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerControllerVariable = self.imagenYVideo()
        imagenResults = realm.objects(NumeroDeImagenes.self)
        if crear == false {
            boton.setTitle("Editar", for: .normal)
        } else {
            boton.setTitle("Crear", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //descargarImg(lugar: "/imagenes/prueba")
    }
    
    
    @IBAction func nombreMateriaAction(_ sender: UITextField) {
        resignFirstResponder()
    }
    
    
    @IBAction func crearOEditarMateria(_ sender: UIButton) {
        if urlScope != nil {
            urlImagenNube = "/imagenes/\(nombreMateriaTextField.text!)\(profesor.text!)"
        }
        let modelo : [String : Any] = ["materia" : nombreMateriaTextField.text!, "profesor" : profesor.text!, "imagen" :  urlImagenNube ?? "/imagenes/Klotho.png"]
        if nombreMateriaTextField!.text == "" && profesor!.text == "" {
            let missingNameAlert = UIAlertController(title: "Parece que te falta algo!", message: "llena todos lops campos primero", preferredStyle: .alert)
            let understoodAction = UIAlertAction(title: "Entendido", style: .cancel)
                       missingNameAlert.addAction(understoodAction)
            self.present(missingNameAlert, animated: true, completion: nil)
        } else {
            if crear == true {
                materiasReferecne.addDocument(data: modelo)
                if urlImagenNube != nil {
                    if imagenResults.count != 0 {
                        let nuevaDireccion = imagenResults.count
                        nuevoCount(valor: nuevaDireccion)
                        subirImagen(imagen: imagenScope!, lugar: "\(urlImagenNube ?? "Klotho.png")")
                    } else if imagenResults.count == 0  {
                        let nuevaDireccion = 0
                        nuevoCount(valor: nuevaDireccion)
                        subirImagen(imagen: imagenScope!, lugar: "\(urlImagenNube ?? "Klotho.png")")
                        }

                }
            } else {
                materiasReferecne.document(materiaSelected!).setData(modelo, merge: true)
            }
            self.dismiss(animated: true, completion: nil)
            crear = true
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageg = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as! URL
            imgSeleccionada.contentMode = .scaleAspectFit
            imgSeleccionada.image = imageg
            imagenScope = imageg
            urlScope = imageUrl
                      }
            dismiss(animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
    }
    
    
    
    func subirImagen (imagen : UIImage, lugar : String ) {
        
        let imagenRef = almacenamientoEnNube.reference().child(lugar)
        guard let imageData = UIImage(data: imagen.jpegData(compressionQuality: 0.25)!) else { return }
            let metaData = StorageMetadata()
            metaData.contentType = "img/jpg"
               
                imagenRef.putData(imageData.jpegData(compressionQuality: 0.25)!, metadata: metaData, completion: { metaData, error in
                if error == nil, metaData != nil {
                    // success
                    imagenRef.downloadURL(completion: { (url, error) in
                        guard let downloadURL = url else {
                        print("ERROR in image link")
                        return
                        }

                    })
                    } else {
                     }
                   })
    }

    func setearImage(from url: String) {
            guard let imageURL = URL(string: url) else { return }
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }

                let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                    self.imgSeleccionada.image = image
                    self.imgSeleccionada.contentMode = .scaleAspectFill
                }
            }
    }

    func descargarImg (lugar : String)  {
        let almacenamientoRef = almacenamientoEnNube.reference()
        let imagenRef = almacenamientoRef.child(lugar)
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localURL = documentsURL.appendingPathComponent(lugar)
        _ = imagenRef.write(toFile: localURL) { url, error in
        if let errorj = error {
        print("aiuda \(errorj)")
        } else {
        self.setearImage(from: "\(localURL)")
            print("exito")
           }
         }
    }
    
    func nuevoCount (valor : Int)  {
        let nuevoCount = NumeroDeImagenes()
        nuevoCount.numeroDeImagenes = valor
        do {
            try realm.write {
                realm.add(nuevoCount)
            }
        } catch  {
            print(error)
        }
        
    }
    func nuevoValorCount (valor : Int) {
        do {
            try realm.write {
                imagenResults.first?.numeroDeImagenes = valor
            }
        } catch  {
            print(error)
        }
    }
    
   
    func imagenYVideo ()-> UIImagePickerController{
        if(pickerControllerVariable == nil){
            pickerControllerVariable = UIImagePickerController()
            pickerControllerVariable.delegate = self
            pickerControllerVariable.allowsEditing = false
        }
        return pickerControllerVariable
    }
}



class BotonSeleccionarImg : UIButton{
    
}

