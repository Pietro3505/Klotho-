import UIKit

class BotonP: UIButton {
    
     static let confi = BotonP()
    
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
        titleLabel?.font   = UIFont(name: "DIN Alternate", size: 25)
        layer.cornerRadius = 30
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

}
