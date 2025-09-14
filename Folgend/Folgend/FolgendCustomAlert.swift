
import UIKit
import SnapKit

// MARK: - Folgend Custom Alert
class FolgendCustomAlert: UIView {
    
    // MARK: - Properties
    private let folgendContainerView = UIView()
    private let folgendScrollView = UIScrollView()
    private let folgendContentView = UIView()
    private let folgendTitleLabel = UILabel()
    private let folgendMessageLabel = UILabel()
    private let folgendTextView = UITextView()
    private let folgendButtonStackView = UIStackView()
    private var folgendBackgroundView: UIView?
    private var folgendHasTextInput = false
    
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
        // Container setup
        folgendContainerView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        folgendContainerView.layer.cornerRadius = 20
        folgendContainerView.layer.shadowColor = UIColor.black.cgColor
        folgendContainerView.layer.shadowOffset = CGSize(width: 0, height: 8)
        folgendContainerView.layer.shadowOpacity = 0.3
        folgendContainerView.layer.shadowRadius = 16
        
        // Scroll view setup
        folgendScrollView.showsVerticalScrollIndicator = true
        folgendScrollView.showsHorizontalScrollIndicator = false
        folgendScrollView.bounces = true
        folgendScrollView.alwaysBounceVertical = false
        
        // Content view setup
        folgendContentView.backgroundColor = UIColor.clear
        
        // Title label setup
        folgendTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        folgendTitleLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        folgendTitleLabel.textAlignment = .center
        folgendTitleLabel.numberOfLines = 0
        
        // Message label setup
        folgendMessageLabel.font = UIFont.systemFont(ofSize: 16)
        folgendMessageLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        folgendMessageLabel.textAlignment = .left
        folgendMessageLabel.numberOfLines = 0
        
        // Text view setup
        folgendTextView.font = UIFont.systemFont(ofSize: 16)
        folgendTextView.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        folgendTextView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
        folgendTextView.layer.cornerRadius = 8
        folgendTextView.layer.borderWidth = 1
        folgendTextView.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        folgendTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        folgendTextView.isHidden = true
        folgendTextView.isScrollEnabled = false
        
        // Stack view setup
        folgendButtonStackView.axis = .horizontal
        folgendButtonStackView.distribution = .fillEqually
        folgendButtonStackView.spacing = 12
        
        // Add subviews
        addSubview(folgendContainerView)
        folgendContainerView.addSubview(folgendScrollView)
        folgendContainerView.addSubview(folgendButtonStackView)
        folgendScrollView.addSubview(folgendContentView)
        folgendContentView.addSubview(folgendTitleLabel)
        folgendContentView.addSubview(folgendMessageLabel)
        folgendContentView.addSubview(folgendTextView)
        
        // Layout
        folgendContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(340) // 增加宽度
            make.height.lessThanOrEqualTo(600) // 增加最大高度
            make.height.greaterThanOrEqualTo(400) // 增加最小高度
        }
        
        // ScrollView layout
        folgendScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(folgendButtonStackView.snp.top).offset(-20)
        }
        
        // ContentView layout
        folgendContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(folgendScrollView.snp.width)
        }
        
        // Button stack view layout (fixed at bottom)
        folgendButtonStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        // Content layout inside scroll view
        folgendTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        folgendMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(folgendTitleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        folgendTextView.snp.makeConstraints { make in
            make.top.equalTo(folgendMessageLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(100)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
    
    // MARK: - Configuration
    func folgendConfigure(folgendTitle: String, folgendMessage: String, folgendActions: [FolgendAlertAction]) {
        folgendTitleLabel.text = folgendTitle
        folgendMessageLabel.text = folgendMessage
        folgendHasTextInput = false
        folgendTextView.isHidden = true
        
        folgendUpdateConstraints()
        folgendSetupButtons(folgendActions)
    }
    
    func folgendConfigureWithTextInput(folgendTitle: String, folgendMessage: String, folgendPlaceholder: String, folgendActions: [FolgendAlertAction]) {
        folgendTitleLabel.text = folgendTitle
        folgendMessageLabel.text = folgendMessage
        folgendTextView.text = folgendPlaceholder
        folgendTextView.textColor = UIColor.placeholderText
        folgendHasTextInput = true
        folgendTextView.isHidden = false
        
        // Add delegate to handle placeholder behavior
        folgendTextView.delegate = self
        
        folgendUpdateConstraints()
        folgendSetupButtons(folgendActions)
    }
    
    private func folgendUpdateConstraints() {
        // Update content view bottom constraint based on whether text input is shown
        folgendContentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(folgendScrollView.snp.width)
        }
        
        // Update the bottom constraint of the content
        if folgendHasTextInput {
            folgendTextView.snp.remakeConstraints { make in
                make.top.equalTo(folgendMessageLabel.snp.bottom).offset(20)
                make.leading.trailing.equalToSuperview().inset(24)
                make.height.equalTo(100)
                make.bottom.equalToSuperview().offset(-24)
            }
        } else {
            folgendMessageLabel.snp.remakeConstraints { make in
                make.top.equalTo(folgendTitleLabel.snp.bottom).offset(20)
                make.leading.trailing.equalToSuperview().inset(24)
                make.bottom.equalToSuperview().offset(-24)
            }
        }
    }
    
    private func folgendSetupButtons(_ folgendActions: [FolgendAlertAction]) {
        // Clear existing buttons
        folgendButtonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add action buttons
        for folgendAction in folgendActions {
            let folgendButton = FolgendCustomButton()
            folgendButton.setTitle(folgendAction.folgendTitle, for: .normal)
            folgendButton.folgendApplyStyle(folgendAction.folgendStyle == .destructive ? .primary : .secondary)
            folgendButton.addTarget(self, action: #selector(folgendButtonTapped(_:)), for: .touchUpInside)
            folgendButton.tag = folgendActions.firstIndex(where: { $0.folgendTitle == folgendAction.folgendTitle }) ?? 0
            folgendButtonStackView.addArrangedSubview(folgendButton)
        }
        
        // Store actions for later use
        objc_setAssociatedObject(self, &FolgendAssociatedKeys.folgendActions, folgendActions, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    // MARK: - Text Input
    func folgendGetTextInput() -> String? {
        guard folgendHasTextInput else { return nil }
        let text = folgendTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        return text?.isEmpty == true ? nil : text
    }
    
    @objc private func folgendButtonTapped(_ sender: UIButton) {
        guard let folgendActions = objc_getAssociatedObject(self, &FolgendAssociatedKeys.folgendActions) as? [FolgendAlertAction],
              sender.tag < folgendActions.count else { return }
        
        let folgendAction = folgendActions[sender.tag]
        folgendDismiss {
            folgendAction.folgendHandler?()
        }
    }
    
    // MARK: - Show/Dismiss
    func folgendShow(in folgendViewController: UIViewController) {
        guard let folgendWindow = folgendViewController.view.window else { return }
        
        // Create background view
        folgendBackgroundView = UIView(frame: folgendWindow.bounds)
        folgendBackgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        folgendBackgroundView?.alpha = 0
        
        // Add to window
        folgendWindow.addSubview(folgendBackgroundView!)
        folgendBackgroundView?.addSubview(self)
        
        self.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // Initial state
        folgendContainerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        folgendContainerView.alpha = 0
        
        // Animate in
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.folgendBackgroundView?.alpha = 1
            self.folgendContainerView.transform = .identity
            self.folgendContainerView.alpha = 1
        }
    }
    
    private func folgendDismiss(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2) {
            self.folgendBackgroundView?.alpha = 0
            self.folgendContainerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.folgendContainerView.alpha = 0
        } completion: { _ in
            self.folgendBackgroundView?.removeFromSuperview()
            self.removeFromSuperview()
            completion?()
        }
    }
}

// MARK: - Folgend Alert Action
struct FolgendAlertAction {
    let folgendTitle: String
    let folgendStyle: FolgendAlertActionStyle
    let folgendHandler: (() -> Void)?
    
    init(folgendTitle: String, folgendStyle: FolgendAlertActionStyle = .default, folgendHandler: (() -> Void)? = nil) {
        self.folgendTitle = folgendTitle
        self.folgendStyle = folgendStyle
        self.folgendHandler = folgendHandler
    }
}

enum FolgendAlertActionStyle {
    case `default`
    case destructive
}

// MARK: - UITextViewDelegate
extension FolgendCustomAlert: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = ""
            textView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter text here..."
            textView.textColor = UIColor.placeholderText
        }
    }
}

// MARK: - Associated Keys
private struct FolgendAssociatedKeys {
    static var folgendActions = "folgendActions"
}
