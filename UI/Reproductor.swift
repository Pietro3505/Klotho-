import Foundation
import AVFoundation

class reproductor {
    
    static let compartido   = reproductor()
    var audioP              : AVAudioPlayer?
    var audioPlayerCorrecto : AVAudioPlayer?
    var audioPlayerNotas    : AVAudioPlayer?
    
    //MARK: Musica
    func play(nombre : String)  {
        do {
            audioP  = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: nombre, ofType: "mp3")!))
            audioP!.numberOfLoops = -1
            audioP!.play()
        } catch  {
            print(error)
        }
    }
    func cambiarVolumen(volumen : Float)  {
        audioP?.volume = volumen
    }

    func detener()  {
    audioP?.currentTime = 0
    audioP?.pause()
    }
    
    //MARK: Correcto
    func playCorrecto(nombre : String)  {
          do {
              audioPlayerCorrecto  = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: nombre, ofType: "mp3")!))
              audioPlayerCorrecto!.numberOfLoops = 0
              audioPlayerCorrecto!.play()
          } catch  {
              print(error)
          }
      }
    //MARK: Notas de Voz
    func playNota(nombre : URL)  {
          do {
               audioPlayerNotas  = try AVAudioPlayer(contentsOf: nombre)
               audioPlayerNotas!.play()
           } catch  {
               print(error)
           }
       }

        func detenerNota()  {
        audioPlayerNotas?.pause()
        }
        func reanudar () {
        audioPlayerNotas?.play()
        }
    func avanzar() {
        audioPlayerNotas?.play(atTime: audioPlayerNotas!.currentTime + 10 )
    }
    func retroceder() {
        audioPlayerNotas?.play(atTime: audioPlayerNotas!.currentTime - 10 )
    }
}
