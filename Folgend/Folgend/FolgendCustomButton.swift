
import UIKit
import SnapKit

// MARK: - Folgend Custom Button
class FolgendCustomButton: UIButton {
    
    // MARK: - Properties
    private var folgendOriginalTransform: CGAffineTransform = .identity
    private var folgendGradientLayer: CAGradientLayer?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        folgendSetupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        folgendSetupButton()
    }
    
    convenience init(folgendTitle: String, folgendStyle: FolgendButtonStyle = .primary) {
        self.init(frame: .zero)
        setTitle(folgendTitle, for: .normal)
        folgendApplyStyle(folgendStyle)
    }
    
    // MARK: - Setup
    private func folgendSetupButton() {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 8
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
        addTarget(self, action: #selector(folgendTouchDown), for: .touchDown)
        addTarget(self, action: #selector(folgendTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        folgendGradientLayer?.frame = bounds
    }
    
    // MARK: - Style Application
    func folgendApplyStyle(_ folgendStyle: FolgendButtonStyle) {
        folgendGradientLayer?.removeFromSuperlayer()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        
        switch folgendStyle {
        case .primary:
            gradientLayer.colors = [
                UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0).cgColor,
                UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 1.0).cgColor
            ]
            setTitleColor(.white, for: .normal)
            
        case .secondary:
            gradientLayer.colors = [
                UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0).cgColor,
                UIColor(red: 0.1, green: 0.4, blue: 0.6, alpha: 1.0).cgColor
            ]
            setTitleColor(.white, for: .normal)
            
        case .success:
            gradientLayer.colors = [
                UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0).cgColor,
                UIColor(red: 0.1, green: 0.6, blue: 0.1, alpha: 1.0).cgColor
            ]
            setTitleColor(.white, for: .normal)
            
        case .warning:
            gradientLayer.colors = [
                UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0).cgColor,
                UIColor(red: 0.8, green: 0.6, blue: 0.1, alpha: 1.0).cgColor
            ]
            setTitleColor(.black, for: .normal)
            
        case .difficulty(let difficulty):
            switch difficulty {
            case .easy:
                gradientLayer.colors = [
                    UIColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1.0).cgColor,
                    UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
                ]
            case .medium:
                gradientLayer.colors = [
                    UIColor(red: 0.8, green: 0.6, blue: 0.2, alpha: 1.0).cgColor,
                    UIColor(red: 0.6, green: 0.4, blue: 0.1, alpha: 1.0).cgColor
                ]
            case .hard:
                gradientLayer.colors = [
                    UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0).cgColor,
                    UIColor(red: 0.6, green: 0.1, blue: 0.1, alpha: 1.0).cgColor
                ]
            }
            setTitleColor(.white, for: .normal)
        }
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        layer.insertSublayer(gradientLayer, at: 0)
        folgendGradientLayer = gradientLayer
    }
    
    // MARK: - Touch Animation
    @objc private func folgendTouchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func folgendTouchUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
        }
    }
}

// MARK: - Folgend Button Style
enum FolgendButtonStyle {
    case primary
    case secondary
    case success
    case warning
    case difficulty(FolgendGameDifficulty)
}
