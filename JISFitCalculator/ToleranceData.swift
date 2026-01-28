import Foundation

// MARK: - 基準寸法区分 (JIS B 0401-1 / ISO 286-1)
struct DimensionRange {
    let min: Double
    let max: Double

    func contains(_ value: Double) -> Bool {
        return value > min && value <= max
    }
}

// 基準寸法区分 (1mm〜500mm)
let dimensionRanges: [DimensionRange] = [
    DimensionRange(min: 0, max: 3),
    DimensionRange(min: 3, max: 6),
    DimensionRange(min: 6, max: 10),
    DimensionRange(min: 10, max: 18),
    DimensionRange(min: 18, max: 30),
    DimensionRange(min: 30, max: 50),
    DimensionRange(min: 50, max: 80),
    DimensionRange(min: 80, max: 120),
    DimensionRange(min: 120, max: 180),
    DimensionRange(min: 180, max: 250),
    DimensionRange(min: 250, max: 315),
    DimensionRange(min: 315, max: 400),
    DimensionRange(min: 400, max: 500)
]

// MARK: - IT基本公差 (μm単位)
// IT等級ごとの公差値 (IT01〜IT18)
// 各配列は基準寸法区分の順に対応
// 0-3, 3-6, 6-10, 10-18, 18-30, 30-50, 50-80, 80-120, 120-180, 180-250, 250-315, 315-400, 400-500
let itTolerances: [String: [Int]] = [
    "IT01": [0, 0, 0, 1, 1, 1, 1, 2, 2, 3, 3, 3, 4],
    "IT0": [0, 1, 1, 1, 1, 1, 2, 2, 3, 3, 4, 4, 4],
    "IT1": [1, 1, 1, 1, 2, 2, 2, 3, 4, 4, 5, 5, 6],
    "IT2": [1, 2, 2, 2, 3, 3, 4, 4, 5, 6, 7, 7, 8],
    "IT3": [2, 2, 3, 3, 4, 4, 5, 6, 8, 9, 10, 11, 12],
    "IT4": [3, 4, 4, 5, 6, 7, 8, 10, 12, 14, 16, 18, 20],
    "IT5": [4, 5, 6, 8, 9, 11, 13, 15, 18, 20, 23, 25, 27],
    "IT6": [6, 8, 9, 11, 13, 16, 19, 22, 25, 29, 32, 36, 40],
    "IT7": [10, 12, 15, 18, 21, 25, 30, 35, 40, 46, 52, 57, 63],
    "IT8": [14, 18, 22, 27, 33, 39, 46, 54, 63, 72, 81, 89, 97],
    "IT9": [25, 30, 36, 43, 52, 62, 74, 87, 100, 115, 130, 140, 155],
    "IT10": [40, 48, 58, 70, 84, 100, 120, 140, 160, 185, 210, 230, 250],
    "IT11": [60, 75, 90, 110, 130, 160, 190, 220, 250, 290, 320, 360, 400],
    "IT12": [100, 120, 150, 180, 210, 250, 300, 350, 400, 460, 520, 570, 630],
    "IT13": [140, 180, 220, 270, 330, 390, 460, 540, 630, 720, 810, 890, 970],
    "IT14": [250, 300, 360, 430, 520, 620, 740, 870, 1000, 1150, 1300, 1400, 1550],
    "IT15": [400, 480, 580, 700, 840, 1000, 1200, 1400, 1600, 1850, 2100, 2300, 2500],
    "IT16": [600, 750, 900, 1100, 1300, 1600, 1900, 2200, 2500, 2900, 3200, 3600, 4000],
    "IT17": [1000, 1200, 1500, 1800, 2100, 2500, 3000, 3500, 4000, 4600, 5200, 5700, 6300],
    "IT18": [1400, 1800, 2200, 2700, 3300, 3900, 4600, 5400, 6300, 7200, 8100, 8900, 9700]
]

// MARK: - 軸の基本寸法許容差 (μm単位)
// 軸の上の寸法許容差 (es) - a〜hは負、j〜zcは正または特殊
// 各配列は基準寸法区分の順に対応
let shaftDeviations: [String: [Int]] = [
    // すきまばめ軸 (es: 上の寸法許容差)
    "a": [-270, -270, -280, -290, -300, -310, -320, -340, -360, -380, -410, -440, -480],
    "b": [-140, -140, -150, -150, -160, -170, -180, -190, -200, -215, -230, -240, -260],
    "c": [-60, -70, -80, -95, -110, -120, -140, -160, -185, -210, -240, -270, -300],
    "cd": [-34, -46, -56, -68, -80, -94, -110, -126, -148, -170, -198, -226, -252],
    "d": [-20, -30, -40, -50, -65, -80, -100, -120, -145, -170, -190, -210, -230],
    "e": [-14, -20, -25, -32, -40, -50, -60, -72, -85, -100, -110, -125, -135],
    "ef": [-10, -14, -18, -23, -28, -35, -43, -51, -61, -71, -79, -88, -96],
    "f": [-6, -10, -13, -16, -20, -25, -30, -36, -43, -50, -56, -62, -68],
    "fg": [-4, -6, -8, -10, -12, -14, -18, -22, -26, -30, -34, -38, -42],
    "g": [-2, -4, -5, -6, -7, -9, -10, -12, -14, -15, -17, -18, -20],
    "h": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],

    // 対称公差
    "js": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 特殊処理: ±IT/2

    // 中間ばめ・しまりばめ軸 (ei: 下の寸法許容差が正方向)
    "j": [2, 3, 4, 5, 5, 6, 7, 7, 7, 8, 9, 9, 10],  // IT5-IT8向け近似値
    "k": [0, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 5],
    "m": [2, 4, 6, 7, 8, 9, 11, 13, 15, 17, 20, 21, 23],
    "n": [4, 8, 10, 12, 15, 17, 20, 23, 27, 31, 34, 37, 40],
    "p": [6, 12, 15, 18, 22, 26, 32, 37, 43, 50, 56, 62, 68],
    "r": [10, 15, 19, 23, 28, 34, 41, 48, 55, 63, 70, 78, 86],
    "s": [14, 19, 23, 28, 35, 43, 53, 59, 68, 79, 88, 98, 108],
    "t": [18, 23, 28, 33, 41, 54, 70, 81, 93, 109, 126, 143, 160],
    "u": [18, 28, 34, 40, 49, 64, 80, 94, 112, 133, 150, 169, 190],
    "v": [20, 32, 39, 47, 59, 75, 95, 117, 143, 170, 195, 220, 250],
    "x": [26, 40, 49, 59, 73, 93, 117, 147, 180, 215, 250, 285, 320],
    "y": [32, 50, 62, 75, 92, 118, 148, 185, 230, 280, 325, 370, 420],
    "z": [40, 60, 74, 90, 112, 142, 180, 224, 280, 340, 400, 456, 520],
    "za": [52, 78, 98, 118, 148, 188, 236, 296, 370, 455, 530, 610, 690],
    "zb": [66, 100, 130, 160, 200, 250, 315, 395, 490, 595, 700, 800, 900],
    "zc": [80, 130, 170, 210, 260, 325, 400, 510, 630, 770, 900, 1030, 1150]
]

// MARK: - 穴の基本寸法許容差 (μm単位)
// 穴の下の寸法許容差 (EI) - A〜Hは正、J〜ZCは特殊または負
let holeDeviations: [String: [Int]] = [
    // すきまばめ穴 (EI: 下の寸法許容差が正方向)
    "A": [270, 270, 280, 290, 300, 310, 320, 340, 360, 380, 410, 440, 480],
    "B": [140, 140, 150, 150, 160, 170, 180, 190, 200, 215, 230, 240, 260],
    "C": [60, 70, 80, 95, 110, 120, 140, 160, 185, 210, 240, 270, 300],
    "CD": [34, 46, 56, 68, 80, 94, 110, 126, 148, 170, 198, 226, 252],
    "D": [20, 30, 40, 50, 65, 80, 100, 120, 145, 170, 190, 210, 230],
    "E": [14, 20, 25, 32, 40, 50, 60, 72, 85, 100, 110, 125, 135],
    "EF": [10, 14, 18, 23, 28, 35, 43, 51, 61, 71, 79, 88, 96],
    "F": [6, 10, 13, 16, 20, 25, 30, 36, 43, 50, 56, 62, 68],
    "FG": [4, 6, 8, 10, 12, 14, 18, 22, 26, 30, 34, 38, 42],
    "G": [2, 4, 5, 6, 7, 9, 10, 12, 14, 15, 17, 18, 20],
    "H": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],

    // 対称公差
    "JS": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],  // 特殊処理: ±IT/2

    // 中間ばめ・しまりばめ穴 (ES: 上の寸法許容差が負方向)
    "J": [2, 3, 4, 5, 5, 6, 7, 7, 7, 8, 9, 9, 10],  // IT5-IT8向け近似値
    "K": [0, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 5],
    "M": [2, 4, 6, 7, 8, 9, 11, 13, 15, 17, 20, 21, 23],
    "N": [4, 8, 10, 12, 15, 17, 20, 23, 27, 31, 34, 37, 40],
    "P": [6, 12, 15, 18, 22, 26, 32, 37, 43, 50, 56, 62, 68],
    "R": [10, 15, 19, 23, 28, 34, 41, 48, 55, 63, 70, 78, 86],
    "S": [14, 19, 23, 28, 35, 43, 53, 59, 68, 79, 88, 98, 108],
    "T": [18, 23, 28, 33, 41, 54, 70, 81, 93, 109, 126, 143, 160],
    "U": [18, 28, 34, 40, 49, 64, 80, 94, 112, 133, 150, 169, 190],
    "V": [20, 32, 39, 47, 59, 75, 95, 117, 143, 170, 195, 220, 250],
    "X": [26, 40, 49, 59, 73, 93, 117, 147, 180, 215, 250, 285, 320],
    "Y": [32, 50, 62, 75, 92, 118, 148, 185, 230, 280, 325, 370, 420],
    "Z": [40, 60, 74, 90, 112, 142, 180, 224, 280, 340, 400, 456, 520],
    "ZA": [52, 78, 98, 118, 148, 188, 236, 296, 370, 455, 530, 610, 690],
    "ZB": [66, 100, 130, 160, 200, 250, 315, 395, 490, 595, 700, 800, 900],
    "ZC": [80, 130, 170, 210, 260, 325, 400, 510, 630, 770, 900, 1030, 1150]
]

// MARK: - 公差域クラスの分類
// すきまばめ軸（es < 0）
let clearanceShaftClasses = ["a", "b", "c", "cd", "d", "e", "ef", "f", "fg", "g", "h"]
// 中間ばめ・しまりばめ軸（ei > 0）
let transitionInterferenceShaftClasses = ["j", "js", "k", "m", "n", "p", "r", "s", "t", "u", "v", "x", "y", "z", "za", "zb", "zc"]

// すきまばめ穴（EI > 0）
let clearanceHoleClasses = ["A", "B", "C", "CD", "D", "E", "EF", "F", "FG", "G", "H"]
// 中間ばめ・しまりばめ穴（ES < 0）
let transitionInterferenceHoleClasses = ["J", "JS", "K", "M", "N", "P", "R", "S", "T", "U", "V", "X", "Y", "Z", "ZA", "ZB", "ZC"]

// 全ての軸公差域クラス
let allShaftClasses = clearanceShaftClasses + transitionInterferenceShaftClasses.filter { $0 != "js" && $0 != "j" } + ["js", "j"]
// 全ての穴公差域クラス
let allHoleClasses = clearanceHoleClasses + transitionInterferenceHoleClasses.filter { $0 != "JS" && $0 != "J" } + ["JS", "J"]

// MARK: - 利用可能なIT等級
let availableGrades = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
// 常用される等級
let commonGrades = [5, 6, 7, 8, 9, 10, 11]

// MARK: - 公差計算クラス
class ToleranceCalculator {

    // 基準寸法区分のインデックスを取得
    func getDimensionRangeIndex(for diameter: Double) -> Int? {
        for (index, range) in dimensionRanges.enumerated() {
            if range.contains(diameter) {
                return index
            }
        }
        return nil
    }

    // IT公差値を取得 (μm)
    func getITTolerance(grade: Int, rangeIndex: Int) -> Int? {
        let key = "IT\(grade)"
        guard let tolerances = itTolerances[key], rangeIndex < tolerances.count else {
            return nil
        }
        return tolerances[rangeIndex]
    }

    // 穴の公差を計算
    func calculateHoleTolerance(diameter: Double, toleranceClass: String) -> ToleranceResult? {
        guard let rangeIndex = getDimensionRangeIndex(for: diameter) else {
            return nil
        }

        // 公差域クラスを解析 (例: "H7" -> letter="H", grade=7)
        let letter = String(toleranceClass.prefix(while: { $0.isLetter }))
        let gradeStr = String(toleranceClass.suffix(from: toleranceClass.index(toleranceClass.startIndex, offsetBy: letter.count)))

        guard let grade = Int(gradeStr),
              let itValue = getITTolerance(grade: grade, rangeIndex: rangeIndex),
              let deviations = holeDeviations[letter] else {
            return nil
        }

        let baseDeviation = deviations[rangeIndex]

        var upperDeviation: Int
        var lowerDeviation: Int

        if letter == "JS" {
            // JS: 対称公差
            upperDeviation = itValue / 2
            lowerDeviation = -(itValue / 2)
        } else if clearanceHoleClasses.contains(letter) {
            // すきまばめ穴: EIが正方向（H含む）
            lowerDeviation = baseDeviation
            upperDeviation = lowerDeviation + itValue
        } else {
            // 中間ばめ・しまりばめ穴: ESが負方向
            if letter == "J" {
                // J: IT等級によって変わる特殊ケース（簡易版）
                upperDeviation = baseDeviation
                lowerDeviation = upperDeviation - itValue
            } else {
                upperDeviation = -baseDeviation
                lowerDeviation = upperDeviation - itValue
            }
        }

        return ToleranceResult(
            nominalDiameter: diameter,
            toleranceClass: toleranceClass,
            upperDeviation: Double(upperDeviation) / 1000.0,
            lowerDeviation: Double(lowerDeviation) / 1000.0,
            isHole: true
        )
    }

    // 軸の公差を計算
    func calculateShaftTolerance(diameter: Double, toleranceClass: String) -> ToleranceResult? {
        guard let rangeIndex = getDimensionRangeIndex(for: diameter) else {
            return nil
        }

        // 公差域クラスを解析 (例: "h7" -> letter="h", grade=7)
        let letter = String(toleranceClass.prefix(while: { $0.isLetter }))
        let gradeStr = String(toleranceClass.suffix(from: toleranceClass.index(toleranceClass.startIndex, offsetBy: letter.count)))

        guard let grade = Int(gradeStr),
              let itValue = getITTolerance(grade: grade, rangeIndex: rangeIndex),
              let deviations = shaftDeviations[letter] else {
            return nil
        }

        let baseDeviation = deviations[rangeIndex]

        var upperDeviation: Int
        var lowerDeviation: Int

        if letter == "js" {
            // js: 対称公差
            upperDeviation = itValue / 2
            lowerDeviation = -(itValue / 2)
        } else if clearanceShaftClasses.contains(letter) {
            // すきまばめ軸: esが負方向（h含む）
            upperDeviation = baseDeviation
            lowerDeviation = upperDeviation - itValue
        } else {
            // 中間ばめ・しまりばめ軸: eiが正方向
            if letter == "j" {
                // j: IT等級によって変わる特殊ケース（簡易版）
                lowerDeviation = -baseDeviation
                upperDeviation = lowerDeviation + itValue
            } else {
                lowerDeviation = baseDeviation
                upperDeviation = lowerDeviation + itValue
            }
        }

        return ToleranceResult(
            nominalDiameter: diameter,
            toleranceClass: toleranceClass,
            upperDeviation: Double(upperDeviation) / 1000.0,
            lowerDeviation: Double(lowerDeviation) / 1000.0,
            isHole: false
        )
    }

    // はめあいを計算
    func calculateFit(diameter: Double, holeClass: String, shaftClass: String) -> FitResult? {
        guard let holeTolerance = calculateHoleTolerance(diameter: diameter, toleranceClass: holeClass),
              let shaftTolerance = calculateShaftTolerance(diameter: diameter, toleranceClass: shaftClass) else {
            return nil
        }

        // すきま/しめしろの計算
        let maxClearance = holeTolerance.upperDeviation - shaftTolerance.lowerDeviation
        let minClearance = holeTolerance.lowerDeviation - shaftTolerance.upperDeviation

        // はめあいの種類を判定
        let fitType: FitType
        if minClearance > 0.0001 {  // 小さな正の値の場合も考慮
            fitType = .clearance  // すきまばめ
        } else if maxClearance < -0.0001 {
            fitType = .interference  // しまりばめ
        } else {
            fitType = .transition  // 中間ばめ
        }

        return FitResult(
            holeTolerance: holeTolerance,
            shaftTolerance: shaftTolerance,
            maxClearance: maxClearance,
            minClearance: minClearance,
            fitType: fitType
        )
    }

    // 利用可能な公差域クラスを生成
    func generateToleranceClasses(letters: [String], grades: [Int]) -> [String] {
        var classes: [String] = []
        for letter in letters {
            for grade in grades {
                classes.append("\(letter)\(grade)")
            }
        }
        return classes
    }
}

// MARK: - 結果データ構造
struct ToleranceResult {
    let nominalDiameter: Double
    let toleranceClass: String
    let upperDeviation: Double  // mm単位
    let lowerDeviation: Double  // mm単位
    let isHole: Bool

    var maxDiameter: Double {
        return nominalDiameter + upperDeviation
    }

    var minDiameter: Double {
        return nominalDiameter + lowerDeviation
    }

    var toleranceValue: Double {
        return upperDeviation - lowerDeviation
    }
}

enum FitType: String {
    case clearance = "すきまばめ"
    case transition = "中間ばめ"
    case interference = "しまりばめ"

    var color: String {
        switch self {
        case .clearance: return "green"
        case .transition: return "orange"
        case .interference: return "red"
        }
    }

    var description: String {
        switch self {
        case .clearance:
            return "常にすきまが生じる組み合わせです。回転部や摺動部に適しています。"
        case .transition:
            return "すきまとしめしろの両方が生じる可能性がある組み合わせです。位置決めに適しています。"
        case .interference:
            return "常にしめしろが生じる組み合わせです。圧入や焼きばめに適しています。"
        }
    }
}

struct FitResult {
    let holeTolerance: ToleranceResult
    let shaftTolerance: ToleranceResult
    let maxClearance: Double  // 最大すきま（正）または最小しめしろ（負）
    let minClearance: Double  // 最小すきま（正）または最大しめしろ（負）
    let fitType: FitType

    var maxInterference: Double {
        return -minClearance  // 最大しめしろ
    }

    var minInterference: Double {
        return -maxClearance  // 最小しめしろ
    }
}
