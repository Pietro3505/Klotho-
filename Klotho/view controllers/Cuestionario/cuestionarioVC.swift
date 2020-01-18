import AVFoundation
import RealmSwift
import ProgressHUD
import UIKit


class cuestionarioVC: UIViewController {

    //MARK: Propiedades
    let realm                  = try! Realm()
    var numeroDePregunta       : Int = 0
    var tiempoRestante         : Int = 2
    var timer                  : Timer?
    var chequearFinal          : Int?
    var numeroDeAciertos       : Int = 0
    var numeroPreguntasGeneral : Int = 0
    
    //MARK: Outlets
    @IBOutlet weak var preguntaL: UILabel!
    @IBOutlet weak var respuesta1O: BotonPregunta!
    @IBOutlet weak var respuesta2O: BotonPregunta!
    @IBOutlet weak var respuesta3O: BotonPregunta!
    @IBOutlet weak var respuesta4O: BotonPregunta!
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var contadorDePreguntas: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cargarPreguntas"), object: nil)
        numeroDePregunta       = 0
        numeroPreguntasGeneral = 0
      
        tituloLabel.text = materiaSeleccionada?.nombreMateria
        contadorDePreguntas.text = "\(numeroDePregunta + 1)/\(preguntas!.count)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cambiarPregunta()
    }
  

  //MARK: Acciones
    
    @IBAction func salirCuestionario(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func respuesta1A(_ sender: BotonPregunta) {
        
        chequearFinal = numeroDePregunta + 1
        desactivar()
        iniciarTimer()
        mostrarMasDeUnaRespuesta(botonTocado: 1)
        if chequearFinal != preguntas?.count {
            numeroDePregunta += 1
        }
        
    }
    @IBAction func respuesta2A(_ sender: BotonPregunta) {
        
        chequearFinal = numeroDePregunta + 1
        desactivar()
        iniciarTimer()
        mostrarMasDeUnaRespuesta(botonTocado: 2)
        print(chequearFinal!)
        if chequearFinal != preguntas?.count {
            numeroDePregunta += 1
            numeroPreguntasGeneral += 1
        }
          
        
    }
    @IBAction func respuesta3A(_ sender: BotonPregunta) {
        
        chequearFinal = numeroDePregunta + 1
        desactivar()
        iniciarTimer()
        mostrarMasDeUnaRespuesta(botonTocado: 3)
        if chequearFinal != preguntas?.count {
            numeroDePregunta += 1
            numeroPreguntasGeneral += 1
        }
        
    }
    @IBAction func respuesta4A(_ sender: BotonPregunta) {
       
        if respuesta3O.isHidden == true {
            self.dismiss(animated: true, completion: nil)
        } else {
            chequearFinal = numeroDePregunta + 1
            desactivar()
            iniciarTimer()
            mostrarMasDeUnaRespuesta(botonTocado: 4)
            if chequearFinal != preguntas?.count {
                numeroDePregunta += 1
                numeroPreguntasGeneral += 1
            }
            
        }
    }
    
    //MARK: Metodos
    
        func cambiarPregunta()  {
            contadorDePreguntas.text = "\(numeroDePregunta + 1)/\(preguntas!.count)"
            preguntaL.text = preguntas![numeroDePregunta].pregunta
            respuesta1O.setTitle(preguntas![numeroDePregunta].respuesta1, for: .normal)
            respuesta2O.setTitle(preguntas![numeroDePregunta].respuesta2, for: .normal)
            respuesta3O.setTitle(preguntas![numeroDePregunta].respuesta3, for: .normal)
            respuesta4O.setTitle(preguntas![numeroDePregunta].respuesta4, for: .normal)
            }
    
        func desactivar () {
            respuesta1O.isEnabled = false
            respuesta2O.isEnabled = false
            respuesta3O.isEnabled = false
            respuesta4O.isEnabled = false
    }
    
   
    
    func finalizar () {
        let numeroDePreguntas    : Int =  preguntas!.count
        if chequearFinal == numeroDePreguntas {
            respuesta1O.isHidden = true
            respuesta3O.isHidden = true
            respuesta2O.isHidden = true
            contadorDePreguntas.isHidden = true
            respuesta4O.setTitle("Entendido", for: .normal)
            if numeroDeAciertos >= numeroDePreguntas/2 && numeroDeAciertos < numeroDePreguntas  {
            preguntaL.text = "Tu numero total de aciertos es \(numeroDeAciertos) de \(preguntas?.count ?? 999) preguntas en total. Se puede decir que estas listo para tu evaluacion de \(materiaSeleccionada?.nombreMateria ?? "") sin embargo podes mejorar"
            } else if numeroDeAciertos < numeroDePreguntas/2 {
                preguntaL.text = "Tu numero total de aciertos es \(numeroDeAciertos) de  \(preguntas?.count ?? 999) preguntas en total. tienes que segir intentando ya que tu puntuacion ha sido menor que la mitad de preguntas que tiene el cuestionario"
            } else {
                reproductor.compartido.playCorrecto(nombre: "ovacion")
                preguntaL.text = "Tu numero total de aciertos es \(numeroDeAciertos) de  \(preguntas?.count ?? 999) preguntas en total. Felicidades respondiste correctamente todas las preguntas"
            }
        }
    }

    func iniciarTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(restar), userInfo: nil, repeats: true)
    }
    
    @objc func restar (){
    tiempoRestante -= 1
        if tiempoRestante <= 0 {
            if chequearFinal != preguntas?.count {
                cambiarPregunta()
            } else {
                finalizar()
            }
            respuesta1O.backgroundColor = UIColor("#3D81AD")
            respuesta2O.backgroundColor = UIColor("#3D81AD")
            respuesta3O.backgroundColor = UIColor("#3D81AD")
            respuesta4O.backgroundColor = UIColor("#3D81AD")
            respuesta1O.isEnabled       = true
            respuesta2O.isEnabled       = true
            respuesta3O.isEnabled       = true
            respuesta4O.isEnabled       = true
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func restarParaFinalizar() {
        tiempoRestante -= 1
            if tiempoRestante <= 0 {
                finalizar()
                respuesta4O.backgroundColor = UIColor("#3D81AD")
                respuesta4O.isEnabled = true
                timer?.invalidate()
                 timer = nil
               
            }
    }
    
    func puntajeFinal() {

    }

    func mostrarMasDeUnaRespuesta (botonTocado:Int){
        if botonTocado == 1 {
         if preguntas![numeroDePregunta].correcto1 == true {
            ProgressHUD.showSuccess("Excelente")
            respuesta1O.backgroundColor = UIColor("#1DB689")
            numeroDeAciertos += 1
         }else if preguntas![numeroDePregunta].correcto1 == false {
            ProgressHUD.showError("Incorrecto")
            respuesta1O.backgroundColor = UIColor("#D65030")
            respuesta1O.sacudida()
            if preguntas![numeroDePregunta].correcto2 || preguntas![numeroDePregunta].correcto3 || preguntas![numeroDePregunta].correcto4 == true {
                if preguntas![numeroDePregunta].correcto2 == true {
                respuesta2O.backgroundColor = UIColor("#1DB689")
                }
                if preguntas![numeroDePregunta].correcto3 == true {
                               respuesta3O.backgroundColor = UIColor("#1DB689")
                               }
                if preguntas![numeroDePregunta].correcto4 == true {
                               respuesta4O.backgroundColor = UIColor("#1DB689")
                               }
            }
            }
            }else if botonTocado == 2 {
                if preguntas![numeroDePregunta].correcto2 == true {
                   ProgressHUD.showSuccess("Excelente")
                   respuesta2O.backgroundColor = UIColor("#1DB689")
                   numeroDeAciertos += 1
                }else if preguntas![numeroDePregunta].correcto2 == false {
                   ProgressHUD.showError("Incorrecto")
                   respuesta2O.backgroundColor = UIColor("#D65030")
                   respuesta2O.sacudida()
                   if preguntas![numeroDePregunta].correcto1 || preguntas![numeroDePregunta].correcto3 || preguntas![numeroDePregunta].correcto4 == true {
                       if preguntas![numeroDePregunta].correcto1 == true {
                       respuesta1O.backgroundColor = UIColor("#1DB689")
                       }
                       if preguntas![numeroDePregunta].correcto3 == true {
                                      respuesta3O.backgroundColor = UIColor("#1DB689")
                                      }
                       if preguntas![numeroDePregunta].correcto4 == true {
                                      respuesta4O.backgroundColor = UIColor("#1DB689")
                                      }
                   }
                   }
                   }else if botonTocado == 3 {
               if preguntas![numeroDePregunta].correcto3 == true {
                  ProgressHUD.showSuccess("Excelente")
                  respuesta3O.backgroundColor = UIColor("#1DB689")
                  numeroDeAciertos += 1
               }else if preguntas![numeroDePregunta].correcto3 == false {
                  ProgressHUD.showError("Incorrecto")
                  respuesta3O.backgroundColor = UIColor("#D65030")
                  respuesta3O.sacudida()
                  if preguntas![numeroDePregunta].correcto2 || preguntas![numeroDePregunta].correcto3 || preguntas![numeroDePregunta].correcto4 == true {
                      if preguntas![numeroDePregunta].correcto1 == true {
                      respuesta1O.backgroundColor = UIColor("#1DB689")
                      }
                      if preguntas![numeroDePregunta].correcto2 == true {
                                     respuesta2O.backgroundColor = UIColor("#1DB689")
                                     }
                      if preguntas![numeroDePregunta].correcto4 == true {
                                     respuesta4O.backgroundColor = UIColor("#1DB689")
                                     }
                        }
                    }
                  }else if botonTocado == 4 {
                if preguntas![numeroDePregunta].correcto4 == true {
                   ProgressHUD.showSuccess("Excelente")
                   respuesta4O.backgroundColor = UIColor("#1DB689")
                   numeroDeAciertos += 1
                }else if preguntas![numeroDePregunta].correcto4 == false {
                   ProgressHUD.showError("Incorrecto")
                   respuesta4O.backgroundColor = UIColor("#D65030")
                   respuesta4O.sacudida()
                   if preguntas![numeroDePregunta].correcto2 || preguntas![numeroDePregunta].correcto3 || preguntas![numeroDePregunta].correcto1 == true {
                            if preguntas![numeroDePregunta].correcto1 == true {
                                respuesta1O.backgroundColor = UIColor("#1DB689")
                            }
                            if preguntas![numeroDePregunta].correcto2 == true {
                                respuesta2O.backgroundColor = UIColor("#1DB689")
                            }
                            if preguntas![numeroDePregunta].correcto3 == true {
                                respuesta3O.backgroundColor = UIColor("#1DB689")
                            }
                    }
                }
            }
    }
    

}
