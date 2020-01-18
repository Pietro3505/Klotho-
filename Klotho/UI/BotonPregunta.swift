import UIKit

class BotonPregunta : UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton()  {
        sombras()
        backgroundColor    = UIColor("#3D81AD")
        titleLabel?.font   = UIFont(name: "DIN Alternate", size: 20)
        layer.cornerRadius = 20
        layer.borderWidth  = 0.0
        layer.borderColor  = backgroundColor?.cgColor
        setTitleColor(UIColor.white, for: .normal)
        setTitle("", for: .normal)
    }
    
    
    private func sombras (){
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 5.0)
        layer.shadowRadius  = 6
        layer.shadowOpacity = 0.5
        clipsToBounds       = true
        layer.masksToBounds = false
    }
    
    func sacudida () {
        let sacudir = CABasicAnimation(keyPath: "position")
        sacudir.duration     = 0.1
        sacudir.repeatCount  = 2
        sacudir.autoreverses = true
        
        let desdePunto = CGPoint(x: center.x - 8, y: center.y)
        let desdeValor = NSValue(cgPoint : desdePunto)
        
        let haciaPunto = CGPoint(x: center.x + 8, y: center.y)
        let haciaValor = NSValue(cgPoint: haciaPunto)
        
        sacudir.fromValue = desdeValor
        sacudir.toValue   = haciaValor
        
        layer.add(sacudir, forKey: "position")
        
    }
}

