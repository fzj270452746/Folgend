

import UIKit
import SnapKit

class FolgendHomeViewController: UIViewController {
    
    // MARK: - UI Properties
    private let folgendScrollView = UIScrollView()
    private let folgendContentView = UIView()
    private let folgendBackgroundImageView = UIImageView()
    private let folgendTitleLabel = UILabel()
    private let folgendSubtitleLabel = UILabel()
    private let folgendDifficultyStackView = UIStackView()
    private let folgendEasyButton = FolgendCustomButton()
    private let folgendMediumButton = FolgendCustomButton()
    private let folgendHardButton = FolgendCustomButton()
    private let folgendLeaderboardButton = FolgendCustomButton()
    private let folgendHowToPlayButton = FolgendCustomButton()
    private let folgendFeedbackButton = FolgendCustomButton()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        folgendSetupUI()
        folgendSetupConstraints()
        folgendSetupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        folgendAnimateEntrance()
    }
    
    // MARK: - UI Setup
    private func folgendSetupUI() {
        view.backgroundColor = UIColor.black
        
        // Background image
        folgendBackgroundImageView.image = UIImage(named: "flogendback")
        folgendBackgroundImageView.contentMode = .scaleAspectFill
        folgendBackgroundImageView.clipsToBounds = true
        
        // Add overlay for better text readability
        let folgendOverlayView = UIView()
        folgendOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // Title
        folgendTitleLabel.text = "Mahjong Folgend"
        folgendTitleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        folgendTitleLabel.textColor = .white
        folgendTitleLabel.textAlignment = .center
        folgendTitleLabel.shadowColor = UIColor.black
        folgendTitleLabel.shadowOffset = CGSize(width: 2, height: 2)
        
        // Subtitle
        folgendSubtitleLabel.text = "Memory Challenge Game"
        folgendSubtitleLabel.font = UIFont.systemFont(ofSize: 18)
        folgendSubtitleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        folgendSubtitleLabel.textAlignment = .center
        folgendSubtitleLabel.shadowColor = UIColor.black
        folgendSubtitleLabel.shadowOffset = CGSize(width: 1, height: 1)
        
        // Difficulty stack view
        folgendDifficultyStackView.axis = .vertical
        folgendDifficultyStackView.spacing = 16
        folgendDifficultyStackView.distribution = .fillEqually
        
        // Buttons configuration
        folgendEasyButton.setTitle("Easy (2×2)", for: .normal)
        folgendEasyButton.folgendApplyStyle(.difficulty(.easy))
        
        folgendMediumButton.setTitle("Medium (3×2)", for: .normal)
        folgendMediumButton.folgendApplyStyle(.difficulty(.medium))
        
        folgendHardButton.setTitle("Hard (3×3)", for: .normal)
        folgendHardButton.folgendApplyStyle(.difficulty(.hard))
        
        folgendLeaderboardButton.setTitle("Leaderboard", for: .normal)
        folgendLeaderboardButton.folgendApplyStyle(.secondary)
        
        folgendHowToPlayButton.setTitle("How to Play", for: .normal)
        folgendHowToPlayButton.folgendApplyStyle(.secondary)
        
        folgendFeedbackButton.setTitle("Feedback", for: .normal)
        folgendFeedbackButton.folgendApplyStyle(.warning)
        
        // Add subviews
        view.addSubview(folgendBackgroundImageView)
        folgendBackgroundImageView.addSubview(folgendOverlayView)
        view.addSubview(folgendScrollView)
        folgendScrollView.addSubview(folgendContentView)
        
        folgendContentView.addSubview(folgendTitleLabel)
        folgendContentView.addSubview(folgendSubtitleLabel)
        folgendContentView.addSubview(folgendDifficultyStackView)
        folgendContentView.addSubview(folgendLeaderboardButton)
        folgendContentView.addSubview(folgendHowToPlayButton)
        folgendContentView.addSubview(folgendFeedbackButton)
        
        folgendDifficultyStackView.addArrangedSubview(folgendEasyButton)
        folgendDifficultyStackView.addArrangedSubview(folgendMediumButton)
        folgendDifficultyStackView.addArrangedSubview(folgendHardButton)
        
        // Overlay constraints
        folgendOverlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func folgendSetupConstraints() {
        folgendBackgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        folgendScrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        folgendContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualTo(view.safeAreaLayoutGuide)
        }
        
        folgendTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        folgendSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(folgendTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        folgendDifficultyStackView.snp.makeConstraints { make in
            make.top.equalTo(folgendSubtitleLabel.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(180)
        }
        
        folgendLeaderboardButton.snp.makeConstraints { make in
            make.top.equalTo(folgendDifficultyStackView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
        
        folgendHowToPlayButton.snp.makeConstraints { make in
            make.top.equalTo(folgendLeaderboardButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
        
        folgendFeedbackButton.snp.makeConstraints { make in
            make.top.equalTo(folgendHowToPlayButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
            make.bottom.lessThanOrEqualToSuperview().offset(-40)
        }
    }
    
    private func folgendSetupActions() {
        folgendEasyButton.addTarget(self, action: #selector(folgendDifficultyButtonTapped(_:)), for: .touchUpInside)
        folgendMediumButton.addTarget(self, action: #selector(folgendDifficultyButtonTapped(_:)), for: .touchUpInside)
        folgendHardButton.addTarget(self, action: #selector(folgendDifficultyButtonTapped(_:)), for: .touchUpInside)
        folgendLeaderboardButton.addTarget(self, action: #selector(folgendLeaderboardButtonTapped), for: .touchUpInside)
        folgendHowToPlayButton.addTarget(self, action: #selector(folgendHowToPlayButtonTapped), for: .touchUpInside)
        folgendFeedbackButton.addTarget(self, action: #selector(folgendFeedbackButtonTapped), for: .touchUpInside)
        
        // Set tags for difficulty buttons
        folgendEasyButton.tag = 0
        folgendMediumButton.tag = 1
        folgendHardButton.tag = 2
    }
    
    // MARK: - Actions
    @objc private func folgendDifficultyButtonTapped(_ sender: UIButton) {
        let folgendDifficulty: FolgendGameDifficulty
        
        switch sender.tag {
        case 0:
            folgendDifficulty = .easy
        case 1:
            folgendDifficulty = .medium
        case 2:
            folgendDifficulty = .hard
        default:
            folgendDifficulty = .easy
        }
        
        let folgendGameVC = FolgendGameViewController(folgendDifficulty: folgendDifficulty)
        navigationController?.pushViewController(folgendGameVC, animated: true)
    }
    
    @objc private func folgendLeaderboardButtonTapped() {
        let folgendLeaderboardVC = FolgendLeaderboardViewController()
        navigationController?.pushViewController(folgendLeaderboardVC, animated: true)
    }
    
    @objc private func folgendHowToPlayButtonTapped() {
        folgendShowHowToPlayAlert()
    }
    
    @objc private func folgendFeedbackButtonTapped() {
        folgendShowFeedbackAlert()
    }
    
    // MARK: - Alert Methods
    private func folgendShowHowToPlayAlert() {
        let folgendAlert = FolgendCustomAlert()
        let folgendMessage = """
        🎯 GAME OBJECTIVE
        Test your memory by recreating the exact sequence of mahjong tiles shown to you!
        
        📋 HOW TO PLAY
        1️⃣ Select Difficulty:
        • Easy: 4 tiles, 10s memorize time
        • Medium: 6 tiles, 8s memorize time  
        • Hard: 8 tiles, 6s memorize time
        
        2️⃣ Watch & Memorize:
        • Tiles appear one by one in sequence
        • Pay attention to the ORDER they appear
        • Use the countdown timer to memorize
        
        3️⃣ Recreate the Sequence:
        • After tiles shuffle, tap them in the ORIGINAL ORDER
        • Green flash = correct selection
        • Red flash = wrong selection (game over)
        
        🏆 SCORING SYSTEM
        • Base points per difficulty level
        • Consecutive wins = BONUS multiplier
        • Higher difficulty = more points
        • Build streaks for maximum scores!
        
        💡 PRO TIPS
        • Focus on tile patterns and positions
        • Create mental associations
        • Practice with easier levels first
        """
        
        let folgendOkAction = FolgendAlertAction(folgendTitle: "Let's Play! 🎮", folgendStyle: .default)
        folgendAlert.folgendConfigure(folgendTitle: "How to Play Folgend", folgendMessage: folgendMessage, folgendActions: [folgendOkAction])
        folgendAlert.folgendShow(in: self)
    }
    
    private func folgendShowFeedbackAlert() {
        let folgendAlert = FolgendCustomAlert()
        
        let folgendSubmitAction = FolgendAlertAction(folgendTitle: "Submit", folgendStyle: .default) { [weak self] in
            guard let self = self,
                  let folgendFeedbackText = folgendAlert.folgendGetTextInput(),
                  !folgendFeedbackText.isEmpty else { return }
            
            self.folgendSaveFeedback(folgendFeedbackText)
            self.folgendShowFeedbackConfirmation()
        }
        
        let folgendCancelAction = FolgendAlertAction(folgendTitle: "Cancel", folgendStyle: .default)
        
        folgendAlert.folgendConfigureWithTextInput(
            folgendTitle: "Feedback",
            folgendMessage: "Please enter your feedback:",
            folgendPlaceholder: "Your feedback...",
            folgendActions: [folgendSubmitAction, folgendCancelAction]
        )
        
        folgendAlert.folgendShow(in: self)
    }
    
    private func folgendSaveFeedback(_ folgendFeedback: String) {
        let folgendFeedbackKey = "FolgendUserFeedback"
        var folgendExistingFeedback = UserDefaults.standard.stringArray(forKey: folgendFeedbackKey) ?? []
        
        let folgendTimestamp = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        let folgendFeedbackEntry = "[\(folgendTimestamp)] \(folgendFeedback)"
        
        folgendExistingFeedback.append(folgendFeedbackEntry)
        UserDefaults.standard.set(folgendExistingFeedback, forKey: folgendFeedbackKey)
    }
    
    private func folgendShowFeedbackConfirmation() {
        let folgendAlert = FolgendCustomAlert()
        let folgendOkAction = FolgendAlertAction(folgendTitle: "OK", folgendStyle: .default)
        folgendAlert.folgendConfigure(folgendTitle: "Thank You!", folgendMessage: "Your feedback has been saved locally.", folgendActions: [folgendOkAction])
        folgendAlert.folgendShow(in: self)
    }
    
    // MARK: - Animation
    private func folgendAnimateEntrance() {
        // Initial state
        folgendTitleLabel.alpha = 0
        folgendSubtitleLabel.alpha = 0
        folgendTitleLabel.transform = CGAffineTransform(translationX: 0, y: -50)
        folgendSubtitleLabel.transform = CGAffineTransform(translationX: 0, y: -30)
        
        let folgendButtons = [folgendEasyButton, folgendMediumButton, folgendHardButton, folgendLeaderboardButton, folgendHowToPlayButton, folgendFeedbackButton]
        
        for (index, button) in folgendButtons.enumerated() {
            button.alpha = 0
            button.transform = CGAffineTransform(translationX: 0, y: 30)
        }
        
        // Animate title
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.folgendTitleLabel.alpha = 1
            self.folgendTitleLabel.transform = .identity
        }
        
        // Animate subtitle
        UIView.animate(withDuration: 0.8, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.folgendSubtitleLabel.alpha = 1
            self.folgendSubtitleLabel.transform = .identity
        }
        
        // Animate buttons
        for (index, button) in folgendButtons.enumerated() {
            UIView.animate(withDuration: 0.6, delay: 0.6 + Double(index) * 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
                button.alpha = 1
                button.transform = .identity
            }
        }
    }
}
