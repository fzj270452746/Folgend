
import UIKit
import SnapKit

class FolgendGameViewController: UIViewController {
    
    // MARK: - Properties
    private let folgendDifficulty: FolgendGameDifficulty
    private var folgendGameTiles: [FolgendMahjongTile] = []
    private var folgendTileViews: [FolgendMahjongTileView] = []
    private var folgendCurrentGameState: FolgendGameState = .folgendWaiting
    private var folgendSelectedOrder: [FolgendMahjongTile] = []
    private var folgendCountdownTimer: Timer?
    private var folgendCountdownValue = 10
    
    // MARK: - UI Properties
    private let folgendBackgroundImageView = UIImageView()
    private let folgendHeaderView = UIView()
    private let folgendTitleLabel = UILabel()
    private let folgendScoreLabel = UILabel()
    private let folgendCountdownLabel = UILabel()
    private let folgendCountdownBackgroundView = UIView()  // Background circle for countdown
    private let folgendGridContainerView = UIView()
    private let folgendStartButton = FolgendCustomButton()
    private let folgendBackButton = FolgendCustomButton()
    
    // MARK: - Initialization
    init(folgendDifficulty: FolgendGameDifficulty) {
        self.folgendDifficulty = folgendDifficulty
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        folgendSetupUI()
        folgendSetupConstraints()
        folgendSetupActions()
        folgendUpdateScoreDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        folgendCleanupTimer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Ensure countdown background is always a perfect circle
        DispatchQueue.main.async {
            let size = min(self.folgendCountdownBackgroundView.bounds.width, self.folgendCountdownBackgroundView.bounds.height)
            if size > 0 {
                self.folgendCountdownBackgroundView.layer.cornerRadius = size / 2
            }
        }
    }
    
    // MARK: - UI Setup
    private func folgendSetupUI() {
        view.backgroundColor = UIColor.black
        
        // Background
        folgendBackgroundImageView.image = UIImage(named: "flogendback")
        folgendBackgroundImageView.contentMode = .scaleAspectFill
        folgendBackgroundImageView.clipsToBounds = true
        
        let folgendOverlayView = UIView()
        folgendOverlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        // Header setup
        folgendHeaderView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        folgendHeaderView.layer.cornerRadius = 12
        
        // Title
        folgendTitleLabel.text = "\(folgendDifficulty.rawValue) Mode"
        folgendTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        folgendTitleLabel.textColor = .white
        folgendTitleLabel.textAlignment = .center
        
        // Score
        folgendScoreLabel.font = UIFont.boldSystemFont(ofSize: 18)
        folgendScoreLabel.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
        folgendScoreLabel.textAlignment = .center
        
        // Countdown
        folgendCountdownLabel.font = UIFont.boldSystemFont(ofSize: 32)
        folgendCountdownLabel.textColor = UIColor.white
        folgendCountdownLabel.textAlignment = .center
        folgendCountdownLabel.isHidden = true
        folgendCountdownLabel.layer.shadowColor = UIColor.black.cgColor
        folgendCountdownLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        folgendCountdownLabel.layer.shadowRadius = 4
        folgendCountdownLabel.layer.shadowOpacity = 0.8
        
        // Remove background from label to prevent rectangular appearance
        folgendCountdownLabel.backgroundColor = UIColor.clear
        folgendCountdownLabel.clipsToBounds = false  // Keep false for shadow effects
        folgendCountdownLabel.layer.borderWidth = 0  // Remove border from label
        folgendCountdownLabel.layer.borderColor = UIColor.clear.cgColor
        
        // Setup circular background view for countdown
        folgendCountdownBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        folgendCountdownBackgroundView.layer.borderWidth = 3
        folgendCountdownBackgroundView.layer.borderColor = UIColor.white.cgColor
        folgendCountdownBackgroundView.isHidden = true
        
        // Grid container
        folgendGridContainerView.backgroundColor = UIColor.clear
        
        // Start button
        folgendStartButton.setTitle("Start Game", for: .normal)
        folgendStartButton.folgendApplyStyle(.success)
        
        // Back button
        folgendBackButton.setTitle("← Back", for: .normal)
        folgendBackButton.folgendApplyStyle(.secondary)
        
        // Add subviews
        view.addSubview(folgendBackgroundImageView)
        folgendBackgroundImageView.addSubview(folgendOverlayView)
        view.addSubview(folgendHeaderView)
        view.addSubview(folgendGridContainerView)
        view.addSubview(folgendStartButton)
        view.addSubview(folgendBackButton)
        view.addSubview(folgendCountdownBackgroundView)  // Add background view first
        view.addSubview(folgendCountdownLabel)  // Add label on top
        
        folgendHeaderView.addSubview(folgendTitleLabel)
        folgendHeaderView.addSubview(folgendScoreLabel)
        
        // Overlay constraints
        folgendOverlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func folgendSetupConstraints() {
        folgendBackgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        folgendHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        folgendTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        folgendScoreLabel.snp.makeConstraints { make in
            make.top.equalTo(folgendTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        folgendGridContainerView.snp.makeConstraints { make in
            make.top.equalTo(folgendCountdownBackgroundView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(folgendGridContainerView.snp.width)
        }
        
        // Background view constraints (same as label)
        folgendCountdownBackgroundView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(folgendHeaderView.snp.bottom).offset(10)
            make.width.height.equalTo(80)
        }
        
        folgendCountdownLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(folgendHeaderView.snp.bottom).offset(10)
            make.width.height.equalTo(80)
        }
        
        folgendStartButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-80)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
        
        folgendBackButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    private func folgendSetupActions() {
        folgendStartButton.addTarget(self, action: #selector(folgendStartButtonTapped), for: .touchUpInside)
        folgendBackButton.addTarget(self, action: #selector(folgendBackButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Game Logic
    @objc private func folgendStartButtonTapped() {
        // Button tap animation
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseOut) {
            self.folgendStartButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: .curveEaseOut) {
                self.folgendStartButton.transform = .identity
            } completion: { _ in
                self.folgendStartGame()
            }
        }
        
        // Haptic feedback
        let folgendImpactFeedback = UIImpactFeedbackGenerator(style: .medium)
        folgendImpactFeedback.impactOccurred()
    }
    
    @objc private func folgendBackButtonTapped() {
        folgendCleanupTimer()
        navigationController?.popViewController(animated: true)
    }
    
    private func folgendStartGame() {
        folgendCurrentGameState = .folgendShowing
        folgendStartButton.isHidden = true
        
        // Reset session score when starting a new game
        FolgendGameManager.folgendShared.folgendResetSessionScore(for: folgendDifficulty)
        
        // Generate tiles
        folgendGameTiles = FolgendGameManager.folgendShared.folgendGenerateRandomTiles(for: folgendDifficulty)
        
        // Create grid
        folgendCreateTileGrid()
        
        // Show tiles in sequence
        folgendShowTilesInSequence()
    }
    
    private func folgendCreateTileGrid() {
        // Clear existing views
        folgendTileViews.forEach { $0.removeFromSuperview() }
        folgendTileViews.removeAll()
        
        let folgendGridSize = folgendDifficulty.folgendGridSize
        let folgendSpacing: CGFloat = 12
        let folgendTileSize = (folgendGridContainerView.frame.width - CGFloat(folgendGridSize.columns - 1) * folgendSpacing) / CGFloat(folgendGridSize.columns)
        
        for (index, tile) in folgendGameTiles.enumerated() {
            let folgendRow = index / folgendGridSize.columns
            let folgendColumn = index % folgendGridSize.columns
            
            let folgendTileView = FolgendMahjongTileView()
            folgendTileView.folgendConfigure(with: tile)
            folgendTileView.folgendTapHandler = { [weak self] tileView in
                self?.folgendTileSelected(tileView)
            }
            
            folgendGridContainerView.addSubview(folgendTileView)
            folgendTileViews.append(folgendTileView)
            
            let folgendX = CGFloat(folgendColumn) * (folgendTileSize + folgendSpacing)
            let folgendY = CGFloat(folgendRow) * (folgendTileSize + folgendSpacing)
            
            folgendTileView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(folgendX)
                make.top.equalToSuperview().offset(folgendY)
                make.width.height.equalTo(folgendTileSize)
            }
        }
    }
    
    private func folgendShowTilesInSequence() {
        for (index, tileView) in folgendTileViews.enumerated() {
            let folgendDelay = Double(index) * 0.3
            tileView.folgendAnimateAppearance(delay: folgendDelay)
        }
        
        // Start countdown after all tiles are shown
        let folgendTotalShowTime = Double(folgendTileViews.count) * 0.3 + 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + folgendTotalShowTime) {
            self.folgendStartCountdown()
        }
    }
    
    private func folgendStartCountdown() {
        folgendCurrentGameState = .folgendMemorizing
        folgendCountdownValue = 10
        
        // Update display IMMEDIATELY after setting the value
        folgendUpdateCountdownDisplay()
        
        folgendCountdownLabel.isHidden = false
        folgendCountdownBackgroundView.isHidden = false
        
        // Dramatic entrance animation
        folgendCountdownLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        folgendCountdownLabel.alpha = 0.0
        
        // Flash effect on background
        let folgendFlashView = UIView()
        folgendFlashView.backgroundColor = UIColor.white
        folgendFlashView.alpha = 0.0
        view.addSubview(folgendFlashView)
        folgendFlashView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.1) {
            folgendFlashView.alpha = 0.3
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                folgendFlashView.alpha = 0.0
            } completion: { _ in
                folgendFlashView.removeFromSuperview()
            }
        }
        
        // Countdown entrance animation
        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.5, initialSpringVelocity: 2.0, options: [.curveEaseOut]) {
            self.folgendCountdownLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.folgendCountdownLabel.alpha = 1.0
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseInOut]) {
                self.folgendCountdownLabel.transform = .identity
            } completion: { _ in
                // Start the countdown timer (display is already updated above)
                self.folgendCountdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                    self?.folgendCountdownTick()
                }
            }
        }
        
        // Add dramatic sound effect with haptic feedback
        let folgendNotificationFeedback = UINotificationFeedbackGenerator()
        folgendNotificationFeedback.notificationOccurred(.warning)
        
        // Additional impact for emphasis
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let folgendImpactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            folgendImpactFeedback.impactOccurred()
        }
    }
    
    private func folgendCountdownTick() {
        folgendCountdownValue -= 1
        folgendUpdateCountdownDisplay()
        
        if folgendCountdownValue == 5 {
            folgendShuffleTiles()
        } else if folgendCountdownValue <= 0 {
            folgendStartPlaying()
        }
    }
    
    private func folgendUpdateCountdownDisplay() {
        folgendCountdownLabel.text = "\(folgendCountdownValue)"
        
        // Different colors based on countdown value
        if folgendCountdownValue <= 3 {
            // Critical: Red with intense glow
            folgendCountdownLabel.textColor = UIColor(red: 1.0, green: 0.1, blue: 0.1, alpha: 1.0)
            folgendCountdownBackgroundView.layer.borderColor = UIColor(red: 1.0, green: 0.1, blue: 0.1, alpha: 1.0).cgColor
            folgendCountdownBackgroundView.backgroundColor = UIColor(red: 0.8, green: 0.0, blue: 0.0, alpha: 0.3)
            
            // Add glow effect
            folgendCountdownLabel.layer.shadowColor = UIColor(red: 1.0, green: 0.1, blue: 0.1, alpha: 1.0).cgColor
            folgendCountdownLabel.layer.shadowRadius = 15
            folgendCountdownLabel.layer.shadowOpacity = 0.8
            
        } else if folgendCountdownValue <= 5 {
            // Warning: Orange
            folgendCountdownLabel.textColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0)
            folgendCountdownBackgroundView.layer.borderColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0).cgColor
            folgendCountdownBackgroundView.backgroundColor = UIColor(red: 1.0, green: 0.4, blue: 0.0, alpha: 0.2)
            
            // Add glow effect
            folgendCountdownLabel.layer.shadowColor = UIColor(red: 1.0, green: 0.6, blue: 0.0, alpha: 1.0).cgColor
            folgendCountdownLabel.layer.shadowRadius = 12
            folgendCountdownLabel.layer.shadowOpacity = 0.7
            
        } else {
            // Safe: Green/White
            folgendCountdownLabel.textColor = UIColor(red: 0.2, green: 1.0, blue: 0.2, alpha: 1.0)
            folgendCountdownBackgroundView.layer.borderColor = UIColor(red: 0.2, green: 1.0, blue: 0.2, alpha: 1.0).cgColor
            folgendCountdownBackgroundView.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 0.2)
            
            // Add glow effect
            folgendCountdownLabel.layer.shadowColor = UIColor(red: 0.2, green: 1.0, blue: 0.2, alpha: 1.0).cgColor
            folgendCountdownLabel.layer.shadowRadius = 10
            folgendCountdownLabel.layer.shadowOpacity = 0.6
        }
        
        // Enhanced pulse animation
        let folgendScaleFactor: CGFloat = folgendCountdownValue <= 3 ? 1.4 : (folgendCountdownValue <= 5 ? 1.3 : 1.2)
        let folgendAnimationDuration: TimeInterval = folgendCountdownValue <= 3 ? 0.3 : 0.5
        
        UIView.animate(withDuration: folgendAnimationDuration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.2, options: [.curveEaseOut, .allowUserInteraction]) {
            self.folgendCountdownLabel.transform = CGAffineTransform(scaleX: folgendScaleFactor, y: folgendScaleFactor)
        } completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [.curveEaseInOut, .allowUserInteraction]) {
                self.folgendCountdownLabel.transform = .identity
            }
        }
        
        // Add rotation effect for critical countdown
        if folgendCountdownValue <= 3 {
            let folgendShakeAnimation = CAKeyframeAnimation(keyPath: "transform.rotation")
            folgendShakeAnimation.values = [0, -Double.pi/24, Double.pi/24, -Double.pi/24, 0]
            folgendShakeAnimation.duration = 0.3
            folgendShakeAnimation.repeatCount = 2
            folgendCountdownLabel.layer.add(folgendShakeAnimation, forKey: "shake")
        }
        
        // Haptic feedback
        if folgendCountdownValue <= 5 {
            let folgendImpactFeedback = UIImpactFeedbackGenerator(style: folgendCountdownValue <= 3 ? .heavy : .medium)
            folgendImpactFeedback.impactOccurred()
        }
    }
    
    private func folgendShuffleTiles() {
        // Animate shuffle
        for tileView in folgendTileViews {
            tileView.folgendAnimateShuffle()
        }
        
        // Shuffle the views positions after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.folgendRearrangeTileViews()
        }
    }
    
    private func folgendRearrangeTileViews() {
        let folgendShuffledTileViews = folgendTileViews.shuffled()
        let folgendGridSize = folgendDifficulty.folgendGridSize
        let folgendSpacing: CGFloat = 12
        let folgendTileSize = (folgendGridContainerView.frame.width - CGFloat(folgendGridSize.columns - 1) * folgendSpacing) / CGFloat(folgendGridSize.columns)
        
        for (index, tileView) in folgendShuffledTileViews.enumerated() {
            let folgendRow = index / folgendGridSize.columns
            let folgendColumn = index % folgendGridSize.columns
            
            let folgendX = CGFloat(folgendColumn) * (folgendTileSize + folgendSpacing)
            let folgendY = CGFloat(folgendRow) * (folgendTileSize + folgendSpacing)
            
            UIView.animate(withDuration: 0.3) {
                tileView.snp.remakeConstraints { make in
                    make.left.equalToSuperview().offset(folgendX)
                    make.top.equalToSuperview().offset(folgendY)
                    make.width.height.equalTo(folgendTileSize)
                }
                self.view.layoutIfNeeded()
            }
        }
        
        folgendTileViews = folgendShuffledTileViews
    }
    
    private func folgendStartPlaying() {
        folgendCleanupTimer()
        folgendCurrentGameState = .folgendPlaying
        folgendSelectedOrder.removeAll()
        
        // Dramatic exit animation for countdown
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: [.curveEaseIn]) {
            self.folgendCountdownLabel.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.folgendCountdownLabel.alpha = 0.0
        } completion: { _ in
            self.folgendCountdownLabel.isHidden = true
            self.folgendCountdownBackgroundView.isHidden = true
            self.folgendCountdownLabel.transform = .identity
            self.folgendCountdownLabel.alpha = 1.0
        }
        
        // Add explosion effect
        let folgendExplosionView = UIView()
        folgendExplosionView.backgroundColor = UIColor.white
        folgendExplosionView.alpha = 0.0
        folgendExplosionView.layer.cornerRadius = 60
        view.addSubview(folgendExplosionView)
        folgendExplosionView.snp.makeConstraints { make in
            make.center.equalTo(folgendCountdownLabel)
            make.width.height.equalTo(120)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.1) {
            folgendExplosionView.alpha = 0.8
            folgendExplosionView.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        } completion: { _ in
            UIView.animate(withDuration: 0.4) {
                folgendExplosionView.alpha = 0.0
                folgendExplosionView.transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
            } completion: { _ in
                folgendExplosionView.removeFromSuperview()
            }
        }
        
        // Hide tiles and enable interaction with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            for tileView in self.folgendTileViews {
                tileView.folgendReset()
            }
        }
        
        // Strong haptic feedback
        let folgendImpactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        folgendImpactFeedback.impactOccurred()
    }
    
    private func folgendTileSelected(_ folgendTileView: FolgendMahjongTileView) {
        guard folgendCurrentGameState == .folgendPlaying,
              let folgendTile = folgendTileView.folgendTileData else { return }
        
        let folgendExpectedTile = folgendGameTiles[folgendSelectedOrder.count]
        
        if folgendTile.folgendId == folgendExpectedTile.folgendId {
            // Correct selection
            folgendSelectedOrder.append(folgendTile)
            folgendTileView.folgendShowOrder(folgendSelectedOrder.count)
            
            if folgendSelectedOrder.count == folgendGameTiles.count {
                // Game completed successfully
                folgendGameCompleted(success: true)
            }
        } else {
            // Wrong selection
            folgendTileView.folgendHighlightAsIncorrect()
            folgendGameCompleted(success: false)
        }
    }
    
    private func folgendGameCompleted(success: Bool) {
        folgendCurrentGameState = .folgendFinished
        
        if success {
            folgendShowGameCompletedAlert()
        } else {
            folgendShowGameFailedAlert()
        }
    }
    
    private func folgendShowGameCompletedAlert() {
        // Play celebration animation first
        folgendPlayCelebrationAnimation {
            let folgendConsecutiveWins = FolgendGameManager.folgendShared.folgendGetConsecutiveWins(for: self.folgendDifficulty) + 1
            FolgendGameManager.folgendShared.folgendIncrementConsecutiveWins(for: self.folgendDifficulty)
            
            // Calculate round score and add to session total
            let folgendRoundScore = FolgendGameManager.folgendShared.folgendCalculateScore(for: self.folgendDifficulty, folgendConsecutiveWins: folgendConsecutiveWins)
            FolgendGameManager.folgendShared.folgendAddToSessionScore(for: self.folgendDifficulty, points: folgendRoundScore)
            
            // Get cumulative session score for saving
            let folgendTotalSessionScore = FolgendGameManager.folgendShared.folgendGetCurrentSessionScore(for: self.folgendDifficulty)
            let folgendGameScore = FolgendGameScore(folgendDifficulty: self.folgendDifficulty, folgendScore: folgendTotalSessionScore, folgendConsecutiveWins: folgendConsecutiveWins)
            FolgendGameManager.folgendShared.folgendSaveScore(folgendGameScore)
            
            // Update score display
            self.folgendUpdateScoreDisplay()
            
            // Show brief success feedback and automatically start next round
            self.folgendShowSuccessFeedback {
                // Automatically start next round after brief celebration
                self.folgendStartNextRound()
            }
        }
    }
    
    private func folgendShowGameFailedAlert() {
        FolgendGameManager.folgendShared.folgendResetConsecutiveWins(for: folgendDifficulty)
        FolgendGameManager.folgendShared.folgendResetSessionScore(for: folgendDifficulty)
        
        // Update score display to reflect reset
        folgendUpdateScoreDisplay()
        
        // Play failure feedback
        folgendPlayFailureAnimation {
            let folgendConsecutiveWins = FolgendGameManager.folgendShared.folgendGetConsecutiveWins(for: self.folgendDifficulty)
            let folgendMessage = "Wrong selection! Your streak has been reset.\n\nFinal streak: \(folgendConsecutiveWins) rounds"
            
            let folgendAlert = FolgendCustomAlert()
            let folgendTryAgainAction = FolgendAlertAction(folgendTitle: "Try Again") { [weak self] in
                self?.folgendResetGame()
            }
            let folgendBackAction = FolgendAlertAction(folgendTitle: "Back to Menu") { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            
            folgendAlert.folgendConfigure(folgendTitle: "Game Over", folgendMessage: folgendMessage, folgendActions: [folgendTryAgainAction, folgendBackAction])
            folgendAlert.folgendShow(in: self)
        }
    }
    
    private func folgendPlayFailureAnimation(completion: @escaping () -> Void) {
        // Screen shake effect
        let folgendShakeAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        folgendShakeAnimation.values = [0, -10, 10, -8, 8, -5, 5, 0]
        folgendShakeAnimation.duration = 0.6
        folgendShakeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        view.layer.add(folgendShakeAnimation, forKey: "shake")
        
        // Red flash effect
        let folgendFlashView = UIView(frame: view.bounds)
        folgendFlashView.backgroundColor = UIColor.red
        folgendFlashView.alpha = 0
        view.addSubview(folgendFlashView)
        
        UIView.animate(withDuration: 0.15) {
            folgendFlashView.alpha = 0.3
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                folgendFlashView.alpha = 0
            } completion: { _ in
                folgendFlashView.removeFromSuperview()
                completion()
            }
        }
        
        // Error haptic feedback
        let folgendErrorFeedback = UINotificationFeedbackGenerator()
        folgendErrorFeedback.notificationOccurred(.error)
    }
    
    private func folgendPlayCelebrationAnimation(completion: @escaping () -> Void) {
        // Animate all tiles with a wave effect
        for (index, tileView) in folgendTileViews.enumerated() {
            let delay = Double(index) * 0.05
            
            UIView.animate(withDuration: 0.4, delay: delay, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .curveEaseOut) {
                tileView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } completion: { _ in
                UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                    tileView.transform = .identity
                }
            }
            
            // Add sparkle effect
            UIView.animate(withDuration: 0.6, delay: delay, options: [.curveEaseInOut, .repeat, .autoreverse]) {
                tileView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.3)
            } completion: { _ in
                tileView.backgroundColor = UIColor.white
            }
        }
        
        // Screen flash effect
        let folgendFlashView = UIView(frame: view.bounds)
        folgendFlashView.backgroundColor = UIColor.white
        folgendFlashView.alpha = 0
        view.addSubview(folgendFlashView)
        
        UIView.animate(withDuration: 0.2) {
            folgendFlashView.alpha = 0.7
        } completion: { _ in
            UIView.animate(withDuration: 0.4) {
                folgendFlashView.alpha = 0
            } completion: { _ in
                folgendFlashView.removeFromSuperview()
                completion()
            }
        }
        
        // Haptic feedback
        let folgendImpactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        folgendImpactFeedback.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let folgendSuccessFeedback = UINotificationFeedbackGenerator()
            folgendSuccessFeedback.notificationOccurred(.success)
        }
    }
    
    private func folgendShowSuccessFeedback(completion: @escaping () -> Void) {
        // Brief success message overlay
        let folgendSuccessLabel = UILabel()
        folgendSuccessLabel.text = "Great! 🎉"
        folgendSuccessLabel.font = UIFont.boldSystemFont(ofSize: 28)
        folgendSuccessLabel.textColor = .white
        folgendSuccessLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.9)
        folgendSuccessLabel.textAlignment = .center
        folgendSuccessLabel.layer.cornerRadius = 12
        folgendSuccessLabel.clipsToBounds = true
        folgendSuccessLabel.alpha = 0
        
        view.addSubview(folgendSuccessLabel)
        folgendSuccessLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(60)
        }
        
        // Animate success feedback
        UIView.animate(withDuration: 0.3, animations: {
            folgendSuccessLabel.alpha = 1.0
            folgendSuccessLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0.8, animations: {
                folgendSuccessLabel.alpha = 0
                folgendSuccessLabel.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }) { _ in
                folgendSuccessLabel.removeFromSuperview()
                completion()
            }
        }
    }
    
    private func folgendStartNextRound() {
        // Clear current round but keep the game state active
        folgendSelectedOrder.removeAll()
        
        // Clear tile views
        folgendTileViews.forEach { $0.removeFromSuperview() }
        folgendTileViews.removeAll()
        
        // Generate NEW tiles for the next round
        folgendGameTiles = FolgendGameManager.folgendShared.folgendGenerateRandomTiles(for: folgendDifficulty)
        
        // Create grid with new tiles and start immediately
        folgendCreateTileGrid()
        folgendShowTilesInSequence()
    }
    
    private func folgendResetGame() {
        folgendCleanupTimer()
        folgendCurrentGameState = .folgendWaiting
        folgendSelectedOrder.removeAll()
        folgendCountdownLabel.isHidden = true
        folgendCountdownBackgroundView.isHidden = true
        folgendStartButton.isHidden = false
        
        // Clear tile views
        folgendTileViews.forEach { $0.removeFromSuperview() }
        folgendTileViews.removeAll()
    }
    
    private func folgendUpdateScoreDisplay() {
        let folgendConsecutiveWins = FolgendGameManager.folgendShared.folgendGetConsecutiveWins(for: folgendDifficulty)
        let folgendCurrentSessionScore = FolgendGameManager.folgendShared.folgendGetCurrentSessionScore(for: folgendDifficulty)
        let folgendTopScores = FolgendGameManager.folgendShared.folgendGetTopScores(for: folgendDifficulty, folgendLimit: 1)
        let folgendBestScore = folgendTopScores.first?.folgendScore ?? 0
        
        folgendScoreLabel.text = "Score: \(folgendCurrentSessionScore) | Best: \(folgendBestScore) | Streak: \(folgendConsecutiveWins)"
    }
    
    private func folgendCleanupTimer() {
        folgendCountdownTimer?.invalidate()
        folgendCountdownTimer = nil
    }
}
