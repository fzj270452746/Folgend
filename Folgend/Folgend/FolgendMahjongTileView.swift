
import UIKit
import SnapKit

// MARK: - Folgend Mahjong Tile View
class FolgendMahjongTileView: UIView {
    
    // MARK: - Properties
    private let folgendImageView = UIImageView()
    private let folgendOrderLabel = UILabel()
    private var folgendTile: FolgendMahjongTile?
    private var folgendIsSelected = false
    private var folgendOrderNumber: Int?
    
    // MARK: - Callbacks
    var folgendTapHandler: ((FolgendMahjongTileView) -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        folgendSetupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        folgendSetupUI()
    }
    
    // MARK: - Setup UI
    private func folgendSetupUI() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor(red: 0.8, green: 0.6, blue: 0.4, alpha: 1.0).cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4
        
        // Image view setup
        folgendImageView.contentMode = .scaleAspectFit
        folgendImageView.clipsToBounds = true
        
        // Order label setup
        folgendOrderLabel.font = UIFont.boldSystemFont(ofSize: 16)
        folgendOrderLabel.textColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
        folgendOrderLabel.textAlignment = .center
        folgendOrderLabel.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        folgendOrderLabel.layer.cornerRadius = 12
        folgendOrderLabel.layer.masksToBounds = true
        folgendOrderLabel.isHidden = true
        
        // Add subviews
        addSubview(folgendImageView)
        addSubview(folgendOrderLabel)
        
        // Layout
        folgendImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        folgendOrderLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(4)
            make.width.height.equalTo(24)
        }
        
        // Tap gesture
        let folgendTapGesture = UITapGestureRecognizer(target: self, action: #selector(folgendTileViewTapped))
        addGestureRecognizer(folgendTapGesture)
    }
    
    // MARK: - Configuration
    func folgendConfigure(with folgendTile: FolgendMahjongTile) {
        self.folgendTile = folgendTile
        folgendImageView.image = UIImage(named: folgendTile.folgendImageName)
    }
    
    func folgendShowOrder(_ folgendOrder: Int) {
        folgendOrderNumber = folgendOrder
        folgendOrderLabel.text = "\(folgendOrder)"
        folgendOrderLabel.isHidden = false
        folgendIsSelected = true
        
        // Update appearance for selected state
        layer.borderColor = UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0).cgColor
        layer.borderWidth = 3
        
        // Success pulse for the tile
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            self.backgroundColor = UIColor.green.withAlphaComponent(0.3)
            self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = UIColor.white
                self.transform = .identity
            }
        }
        
        // Bounce animation for order label
        folgendOrderLabel.alpha = 0
        folgendOrderLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.2, options: .curveEaseOut) {
            self.folgendOrderLabel.alpha = 1
            self.folgendOrderLabel.transform = .identity
        }
    }
    
    func folgendReset() {
        folgendOrderLabel.isHidden = true
        folgendIsSelected = false
        folgendOrderNumber = nil
        layer.borderColor = UIColor(red: 0.8, green: 0.6, blue: 0.4, alpha: 1.0).cgColor
        layer.borderWidth = 2
    }
    
    func folgendHighlightAsCorrect() {
        layer.borderColor = UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 1.0).cgColor
        backgroundColor = UIColor(red: 0.9, green: 1.0, blue: 0.9, alpha: 1.0)
    }
    
    func folgendHighlightAsIncorrect() {
        layer.borderColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0).cgColor
        
        // Flash red background
        let folgendOriginalColor = backgroundColor
        backgroundColor = UIColor.red.withAlphaComponent(0.7)
        
        // Shake animation
        let folgendShakeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        folgendShakeAnimation.values = [0, -15, 15, -10, 10, -5, 5, 0]
        folgendShakeAnimation.duration = 0.6
        folgendShakeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        layer.add(folgendShakeAnimation, forKey: "shake")
        
        // Restore color
        UIView.animate(withDuration: 0.8, delay: 0.2) {
            self.backgroundColor = folgendOriginalColor
        }
        
        // Add error pulse effect
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut, .autoreverse]) {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        }
    }
    
    // MARK: - Animations
    private func folgendAnimateSelection() {
        // Tap feedback animation with spring effect
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        } completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .curveEaseOut) {
                self.transform = .identity
            }
        }
        
        // Add subtle glow effect
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            self.layer.shadowColor = UIColor.systemBlue.cgColor
            self.layer.shadowOpacity = 0.4
            self.layer.shadowRadius = 8
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
        } completion: { _ in
            UIView.animate(withDuration: 0.4) {
                self.layer.shadowOpacity = 0
            }
        }
    }
    
    // MARK: - Actions
    @objc private func folgendTileViewTapped() {
        guard !folgendIsSelected else { return }
        
        // Use the new animation method
        folgendAnimateSelection()
        
        folgendTapHandler?(self)
    }
    
    // MARK: - Animation Methods
    func folgendAnimateAppearance(delay: TimeInterval = 0) {
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.3, y: 0.3).rotated(by: .pi / 4)
        
        UIView.animate(withDuration: 0.8, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseOut) {
            self.alpha = 1
            self.transform = .identity
        }
        
        // Add glow effect during appearance
        UIView.animate(withDuration: 0.3, delay: delay + 0.5) {
            self.layer.shadowOpacity = 0.6
            self.layer.shadowRadius = 8
            self.layer.shadowColor = UIColor.white.cgColor
        } completion: { _ in
            UIView.animate(withDuration: 0.4) {
                self.layer.shadowOpacity = 0.3
                self.layer.shadowRadius = 4
            }
        }
    }
    
    func folgendAnimateShuffle() {
        let folgendRotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
        folgendRotationAnimation.values = [0, Double.pi/6, -Double.pi/6, Double.pi/8, -Double.pi/8, 0]
        folgendRotationAnimation.duration = 0.6
        folgendRotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let folgendScaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        folgendScaleAnimation.values = [1.0, 1.1, 0.9, 1.05, 0.95, 1.0]
        folgendScaleAnimation.duration = 0.6
        folgendScaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.add(folgendRotationAnimation, forKey: "shuffleRotation")
        layer.add(folgendScaleAnimation, forKey: "shuffleScale")
    }
    
    
    // MARK: - Getters
    var folgendTileData: FolgendMahjongTile? {
        return folgendTile
    }
    
    var folgendCurrentOrder: Int? {
        return folgendOrderNumber
    }
    
    var folgendIsCurrentlySelected: Bool {
        return folgendIsSelected
    }
}
