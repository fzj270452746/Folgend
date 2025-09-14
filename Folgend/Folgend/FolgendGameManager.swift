

import Foundation

// MARK: - Folgend Game Manager
class FolgendGameManager {
    static let folgendShared = FolgendGameManager()
    
    private init() {}
    
    // MARK: - Properties
    private let folgendUserDefaults = UserDefaults.standard
    private let folgendScoreKey = "FolgendGameScores"
    private let folgendConsecutiveWinsKey = "FolgendConsecutiveWins"
    
    // Session-based cumulative score tracking
    private var folgendCurrentSessionScores: [FolgendGameDifficulty: Int] = [:]
    
    // MARK: - Score Management
    func folgendSaveScore(_ folgendScore: FolgendGameScore) {
        var folgendScores = folgendGetAllScores()
        folgendScores.append(folgendScore)
        
        let folgendEncoder = JSONEncoder()
        if let folgendEncodedData = try? folgendEncoder.encode(folgendScores) {
            folgendUserDefaults.set(folgendEncodedData, forKey: folgendScoreKey)
        }
    }
    
    func folgendGetAllScores() -> [FolgendGameScore] {
        guard let folgendData = folgendUserDefaults.data(forKey: folgendScoreKey) else {
            return []
        }
        
        let folgendDecoder = JSONDecoder()
        return (try? folgendDecoder.decode([FolgendGameScore].self, from: folgendData)) ?? []
    }
    
    func folgendGetTopScores(for folgendDifficulty: FolgendGameDifficulty, folgendLimit: Int = 10) -> [FolgendGameScore] {
        let folgendAllScores = folgendGetAllScores()
        let folgendFilteredScores = folgendAllScores.filter { 
            $0.folgendDifficulty == folgendDifficulty && $0.folgendScore > 0 
        }
        return Array(folgendFilteredScores.sorted { $0.folgendScore > $1.folgendScore }.prefix(folgendLimit))
    }
    
    // MARK: - Consecutive Wins Management
    func folgendGetConsecutiveWins(for folgendDifficulty: FolgendGameDifficulty) -> Int {
        return folgendUserDefaults.integer(forKey: "\(folgendConsecutiveWinsKey)_\(folgendDifficulty.rawValue)")
    }
    
    func folgendIncrementConsecutiveWins(for folgendDifficulty: FolgendGameDifficulty) {
        let folgendCurrentWins = folgendGetConsecutiveWins(for: folgendDifficulty)
        folgendUserDefaults.set(folgendCurrentWins + 1, forKey: "\(folgendConsecutiveWinsKey)_\(folgendDifficulty.rawValue)")
    }
    
    func folgendResetConsecutiveWins(for folgendDifficulty: FolgendGameDifficulty) {
        folgendUserDefaults.set(0, forKey: "\(folgendConsecutiveWinsKey)_\(folgendDifficulty.rawValue)")
    }
    
    // MARK: - Game Logic
    func folgendGenerateRandomTiles(for folgendDifficulty: FolgendGameDifficulty) -> [FolgendMahjongTile] {
        let folgendAllTiles = FolgendMahjongTile.folgendCreateAllTiles()
        let folgendShuffledTiles = folgendAllTiles.shuffled()
        return Array(folgendShuffledTiles.prefix(folgendDifficulty.folgendTileCount))
    }
    
    func folgendCalculateScore(for folgendDifficulty: FolgendGameDifficulty, folgendConsecutiveWins: Int) -> Int {
        let folgendBaseScore = 10
        let folgendConsecutiveBonus = folgendConsecutiveWins >= 3 ? (folgendConsecutiveWins - 2) * 5 : 0
        let folgendDifficultyMultiplier: Int
        
        switch folgendDifficulty {
        case .easy:
            folgendDifficultyMultiplier = 1
        case .medium:
            folgendDifficultyMultiplier = 2
        case .hard:
            folgendDifficultyMultiplier = 3
        }
        
        return (folgendBaseScore * folgendDifficultyMultiplier) + folgendConsecutiveBonus
    }
    
    // MARK: - Session Score Management
    func folgendGetCurrentSessionScore(for folgendDifficulty: FolgendGameDifficulty) -> Int {
        return folgendCurrentSessionScores[folgendDifficulty] ?? 0
    }
    
    func folgendAddToSessionScore(for folgendDifficulty: FolgendGameDifficulty, points: Int) {
        let currentScore = folgendCurrentSessionScores[folgendDifficulty] ?? 0
        folgendCurrentSessionScores[folgendDifficulty] = currentScore + points
    }
    
    func folgendResetSessionScore(for folgendDifficulty: FolgendGameDifficulty) {
        folgendCurrentSessionScores[folgendDifficulty] = 0
    }
}

// MARK: - Codable Extension for FolgendGameScore
extension FolgendGameScore: Codable {
    enum CodingKeys: String, CodingKey {
        case folgendDifficulty
        case folgendScore
        case folgendDate
        case folgendConsecutiveWins
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let difficultyString = try container.decode(String.self, forKey: .folgendDifficulty)
        self.folgendDifficulty = FolgendGameDifficulty(rawValue: difficultyString) ?? .easy
        self.folgendScore = try container.decode(Int.self, forKey: .folgendScore)
        self.folgendDate = try container.decode(Date.self, forKey: .folgendDate)
        self.folgendConsecutiveWins = try container.decodeIfPresent(Int.self, forKey: .folgendConsecutiveWins) ?? 0
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(folgendDifficulty.rawValue, forKey: .folgendDifficulty)
        try container.encode(folgendScore, forKey: .folgendScore)
        try container.encode(folgendDate, forKey: .folgendDate)
        try container.encode(folgendConsecutiveWins, forKey: .folgendConsecutiveWins)
    }
}
