
import UIKit
import SnapKit

class FolgendLeaderboardViewController: UIViewController {
    
    // MARK: - UI Properties
    private let folgendBackgroundImageView = UIImageView()
    private let folgendHeaderView = UIView()
    private let folgendTitleLabel = UILabel()
    private let folgendSegmentedControl = UISegmentedControl()
    private let folgendTableView = UITableView()
    private let folgendBackButton = FolgendCustomButton()
    private let folgendEmptyStateView = UIView()
    private let folgendEmptyLabel = UILabel()
    
    // MARK: - Properties
    private var folgendCurrentDifficulty: FolgendGameDifficulty = .easy
    private var folgendScores: [FolgendGameScore] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        folgendSetupUI()
        folgendSetupConstraints()
        folgendSetupActions()
        folgendLoadScores()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        folgendLoadScores()
        folgendAnimateEntrance()
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
        
        // Header
        folgendHeaderView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        folgendHeaderView.layer.cornerRadius = 12
        
        // Title
        folgendTitleLabel.text = "Leaderboard"
        folgendTitleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        folgendTitleLabel.textColor = .white
        folgendTitleLabel.textAlignment = .center
        
        // Segmented control
        folgendSegmentedControl.insertSegment(withTitle: "Easy", at: 0, animated: false)
        folgendSegmentedControl.insertSegment(withTitle: "Medium", at: 1, animated: false)
        folgendSegmentedControl.insertSegment(withTitle: "Hard", at: 2, animated: false)
        folgendSegmentedControl.selectedSegmentIndex = 0
        folgendSegmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        folgendSegmentedControl.selectedSegmentTintColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
        folgendSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        folgendSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        
        // Table view
        folgendTableView.backgroundColor = UIColor.clear
        folgendTableView.separatorStyle = .none
        folgendTableView.register(FolgendLeaderboardCell.self, forCellReuseIdentifier: "FolgendLeaderboardCell")
        folgendTableView.delegate = self
        folgendTableView.dataSource = self
        folgendTableView.showsVerticalScrollIndicator = false
        
        // Empty state
        folgendEmptyStateView.backgroundColor = UIColor.clear
        folgendEmptyStateView.isHidden = true
        
        folgendEmptyLabel.text = "No scores yet!\nStart playing to see your scores here."
        folgendEmptyLabel.font = UIFont.systemFont(ofSize: 18)
        folgendEmptyLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        folgendEmptyLabel.textAlignment = .center
        folgendEmptyLabel.numberOfLines = 0
        
        // Back button
        folgendBackButton.setTitle("← Back to Menu", for: .normal)
        folgendBackButton.folgendApplyStyle(.secondary)
        
        // Add subviews
        view.addSubview(folgendBackgroundImageView)
        folgendBackgroundImageView.addSubview(folgendOverlayView)
        view.addSubview(folgendHeaderView)
        view.addSubview(folgendTableView)
        view.addSubview(folgendBackButton)
        view.addSubview(folgendEmptyStateView)
        
        folgendHeaderView.addSubview(folgendTitleLabel)
        folgendHeaderView.addSubview(folgendSegmentedControl)
        folgendEmptyStateView.addSubview(folgendEmptyLabel)
        
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
            make.height.equalTo(120)
        }
        
        folgendTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        folgendSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(folgendTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
        
        folgendTableView.snp.makeConstraints { make in
            make.top.equalTo(folgendHeaderView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(folgendBackButton.snp.top).offset(-20)
        }
        
        folgendEmptyStateView.snp.makeConstraints { make in
            make.edges.equalTo(folgendTableView)
        }
        
        folgendEmptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        folgendBackButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    private func folgendSetupActions() {
        folgendSegmentedControl.addTarget(self, action: #selector(folgendSegmentChanged), for: .valueChanged)
        folgendBackButton.addTarget(self, action: #selector(folgendBackButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func folgendSegmentChanged() {
        switch folgendSegmentedControl.selectedSegmentIndex {
        case 0:
            folgendCurrentDifficulty = .easy
        case 1:
            folgendCurrentDifficulty = .medium
        case 2:
            folgendCurrentDifficulty = .hard
        default:
            folgendCurrentDifficulty = .easy
        }
        
        folgendLoadScores()
    }
    
    @objc private func folgendBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Data Loading
    private func folgendLoadScores() {
        folgendScores = FolgendGameManager.folgendShared.folgendGetTopScores(for: folgendCurrentDifficulty, folgendLimit: 20)
        
        folgendEmptyStateView.isHidden = !folgendScores.isEmpty
        folgendTableView.isHidden = folgendScores.isEmpty
        
        folgendTableView.reloadData()
    }
    
    // MARK: - Animation
    private func folgendAnimateEntrance() {
        folgendHeaderView.alpha = 0
        folgendTableView.alpha = 0
        folgendBackButton.alpha = 0
        
        folgendHeaderView.transform = CGAffineTransform(translationX: 0, y: -50)
        folgendTableView.transform = CGAffineTransform(translationX: 0, y: 30)
        folgendBackButton.transform = CGAffineTransform(translationX: 0, y: 50)
        
        UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.folgendHeaderView.alpha = 1
            self.folgendHeaderView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.folgendTableView.alpha = 1
            self.folgendTableView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.folgendBackButton.alpha = 1
            self.folgendBackButton.transform = .identity
        }
    }
}

// MARK: - Table View Data Source
extension FolgendLeaderboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folgendScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolgendLeaderboardCell", for: indexPath) as! FolgendLeaderboardCell
        let folgendScore = folgendScores[indexPath.row]
        cell.folgendConfigure(with: folgendScore, folgendRank: indexPath.row + 1)
        return cell
    }
}

// MARK: - Table View Delegate
extension FolgendLeaderboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - Folgend Leaderboard Cell
class FolgendLeaderboardCell: UITableViewCell {
    
    // MARK: - UI Properties
    private let folgendContainerView = UIView()
    private let folgendRankLabel = UILabel()
    private let folgendScoreLabel = UILabel()
    private let folgendDateLabel = UILabel()
    private let folgendStreakLabel = UILabel()
    private let folgendMedalImageView = UIImageView()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        folgendSetupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        folgendSetupUI()
    }
    
    // MARK: - Setup
    private func folgendSetupUI() {
        backgroundColor = UIColor.clear
        selectionStyle = .none
        
        // Container
        folgendContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        folgendContainerView.layer.cornerRadius = 12
        folgendContainerView.layer.shadowColor = UIColor.black.cgColor
        folgendContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        folgendContainerView.layer.shadowOpacity = 0.3
        folgendContainerView.layer.shadowRadius = 4
        
        // Rank
        folgendRankLabel.font = UIFont.boldSystemFont(ofSize: 24)
        folgendRankLabel.textAlignment = .center
        
        // Score
        folgendScoreLabel.font = UIFont.boldSystemFont(ofSize: 20)
        folgendScoreLabel.textColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0)
        
        // Date
        folgendDateLabel.font = UIFont.systemFont(ofSize: 14)
        folgendDateLabel.textColor = UIColor.gray
        
        // Streak
        folgendStreakLabel.font = UIFont.systemFont(ofSize: 14)
        folgendStreakLabel.textColor = UIColor(red: 0.2, green: 0.6, blue: 0.8, alpha: 1.0)
        
        // Medal
        folgendMedalImageView.contentMode = .scaleAspectFit
        
        // Add subviews
        contentView.addSubview(folgendContainerView)
        folgendContainerView.addSubview(folgendRankLabel)
        folgendContainerView.addSubview(folgendScoreLabel)
        folgendContainerView.addSubview(folgendDateLabel)
        folgendContainerView.addSubview(folgendStreakLabel)
        folgendContainerView.addSubview(folgendMedalImageView)
        
        // Constraints
        folgendContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
        }
        
        folgendRankLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
        }
        
        folgendMedalImageView.snp.makeConstraints { make in
            make.leading.equalTo(folgendRankLabel.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        folgendScoreLabel.snp.makeConstraints { make in
            make.leading.equalTo(folgendMedalImageView.snp.trailing).offset(12)
            make.top.equalToSuperview().offset(16)
        }
        
        folgendStreakLabel.snp.makeConstraints { make in
            make.leading.equalTo(folgendScoreLabel)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        folgendDateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Configuration
    func folgendConfigure(with folgendScore: FolgendGameScore, folgendRank: Int) {
        folgendRankLabel.text = "#\(folgendRank)"
        folgendScoreLabel.text = "\(folgendScore.folgendScore) pts"
        folgendStreakLabel.text = "Streak: \(folgendScore.folgendConsecutiveWins)"
        
        let folgendFormatter = DateFormatter()
        folgendFormatter.dateStyle = .short
        folgendFormatter.timeStyle = .short
        folgendDateLabel.text = folgendFormatter.string(from: folgendScore.folgendDate)
        
        // Rank colors and medals
        switch folgendRank {
        case 1:
            folgendRankLabel.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0) // Gold
            folgendMedalImageView.isHidden = false
            folgendMedalImageView.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
            folgendMedalImageView.layer.cornerRadius = 12
        case 2:
            folgendRankLabel.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0) // Silver
            folgendMedalImageView.isHidden = false
            folgendMedalImageView.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
            folgendMedalImageView.layer.cornerRadius = 12
        case 3:
            folgendRankLabel.textColor = UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0) // Bronze
            folgendMedalImageView.isHidden = false
            folgendMedalImageView.backgroundColor = UIColor(red: 0.8, green: 0.5, blue: 0.2, alpha: 1.0)
            folgendMedalImageView.layer.cornerRadius = 12
        default:
            folgendRankLabel.textColor = UIColor.black
            folgendMedalImageView.isHidden = true
        }
    }
}
