
import UIKit

// MARK: - Folgend Tile Types
enum FolgendTileType: String, CaseIterable {
    case circle = "circle"
    case wan = "wan"
    case strip = "strip"
    case fangs = "fangs"
}

enum FolgendGameDifficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var folgendGridSize: (rows: Int, columns: Int) {
        switch self {
        case .easy:
            return (2, 2)
        case .medium:
            return (2, 3)
        case .hard:
            return (3, 3)
        }
    }
    
    var folgendTileCount: Int {
        let size = folgendGridSize
        return size.rows * size.columns
    }
}

// MARK: - Folgend Mahjong Tile Model
struct FolgendMahjongTile {
    let folgendType: FolgendTileType
    let folgendNumber: Int
    let folgendImageName: String
    let folgendId: String
    
    init(folgendType: FolgendTileType, folgendNumber: Int) {
        self.folgendType = folgendType
        self.folgendNumber = folgendNumber
        
        if folgendType == .fangs {
            self.folgendImageName = "folgend-fangs-\(folgendNumber)"
        } else {
            self.folgendImageName = "folgend-\(folgendType.rawValue)-\(folgendNumber)"
        }
        
        self.folgendId = "\(folgendType.rawValue)-\(folgendNumber)"
    }
    
    static func folgendCreateAllTiles() -> [FolgendMahjongTile] {
        var folgendTiles: [FolgendMahjongTile] = []
        
        // Add circle, wan, strip tiles (1-9 each)
        for type in [FolgendTileType.circle, .wan, .strip] {
            for number in 1...9 {
                folgendTiles.append(FolgendMahjongTile(folgendType: type, folgendNumber: number))
            }
        }
        
        // Add fangs tiles (1-8)
        for number in 1...8 {
            folgendTiles.append(FolgendMahjongTile(folgendType: .fangs, folgendNumber: number))
        }
        
        return folgendTiles
    }
}

// MARK: - Folgend Game Score Model
struct FolgendGameScore {
    let folgendDifficulty: FolgendGameDifficulty
    let folgendScore: Int
    let folgendDate: Date
    let folgendConsecutiveWins: Int
    
    init(folgendDifficulty: FolgendGameDifficulty, folgendScore: Int, folgendConsecutiveWins: Int = 0) {
        self.folgendDifficulty = folgendDifficulty
        self.folgendScore = folgendScore
        self.folgendDate = Date()
        self.folgendConsecutiveWins = folgendConsecutiveWins
    }
}

// MARK: - Folgend Game State
enum FolgendGameState {
    case folgendWaiting
    case folgendShowing
    case folgendMemorizing
    case folgendPlaying
    case folgendFinished
}
