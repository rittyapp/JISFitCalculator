import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FitCalculatorViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // ヘッダー
                    HeaderView()

                    // 入力セクション
                    InputSection(viewModel: viewModel)

                    // 計算ボタン
                    CalculateButton(viewModel: viewModel)

                    // 結果表示
                    if viewModel.showResult, let result = viewModel.fitResult {
                        ResultSection(result: result)
                    }

                    Spacer(minLength: 50)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }
}

// MARK: - ヘッダー
struct HeaderView: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "gear.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                Text("JIS はめあい公差")
                    .font(.title)
                    .fontWeight(.bold)
            }
            Text("ISO 286 / JIS B 0401 準拠")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
}

// MARK: - 入力セクション
struct InputSection: View {
    @ObservedObject var viewModel: FitCalculatorViewModel

    var body: some View {
        VStack(spacing: 16) {
            // 基準寸法入力
            InputCard(title: "基準寸法", icon: "ruler") {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        TextField("例: 50", text: $viewModel.diameterText)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity)
                        Text("mm")
                            .foregroundColor(.secondary)
                    }
                    Text("範囲: 1 〜 500 mm")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // 表示モード選択
            InputCard(title: "公差クラス表示", icon: "list.bullet") {
                Picker("表示モード", selection: $viewModel.displayMode) {
                    Text("常用").tag(DisplayMode.common)
                    Text("全て").tag(DisplayMode.all)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            // 穴の公差選択
            ToleranceClassSelector(
                title: "穴の公差",
                icon: "circle",
                selectedLetter: $viewModel.selectedHoleLetter,
                selectedGrade: $viewModel.selectedHoleGrade,
                availableLetters: viewModel.availableHoleLetters,
                availableGrades: viewModel.availableGrades,
                color: .blue
            )

            // 軸の公差選択
            ToleranceClassSelector(
                title: "軸の公差",
                icon: "circle.fill",
                selectedLetter: $viewModel.selectedShaftLetter,
                selectedGrade: $viewModel.selectedShaftGrade,
                availableLetters: viewModel.availableShaftLetters,
                availableGrades: viewModel.availableGrades,
                color: .orange
            )
        }
    }
}

// MARK: - 公差域クラス選択
struct ToleranceClassSelector: View {
    let title: String
    let icon: String
    @Binding var selectedLetter: String
    @Binding var selectedGrade: Int
    let availableLetters: [String]
    let availableGrades: [Int]
    let color: Color

    var body: some View {
        InputCard(title: title, icon: icon) {
            VStack(spacing: 12) {
                // 選択結果表示
                HStack {
                    Text("選択中:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(selectedLetter)\(selectedGrade)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(color)
                    Spacer()
                }

                // 公差域クラス（文字）選択
                VStack(alignment: .leading, spacing: 4) {
                    Text("公差域クラス")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(availableLetters, id: \.self) { letter in
                                Button(action: {
                                    selectedLetter = letter
                                }) {
                                    Text(letter)
                                        .font(.system(size: 14, weight: .medium))
                                        .frame(minWidth: 32, minHeight: 32)
                                        .background(selectedLetter == letter ? color : Color(.systemGray5))
                                        .foregroundColor(selectedLetter == letter ? .white : .primary)
                                        .cornerRadius(6)
                                }
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }

                // IT等級選択
                VStack(alignment: .leading, spacing: 4) {
                    Text("IT等級")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(availableGrades, id: \.self) { grade in
                                Button(action: {
                                    selectedGrade = grade
                                }) {
                                    Text("\(grade)")
                                        .font(.system(size: 14, weight: .medium))
                                        .frame(minWidth: 32, minHeight: 32)
                                        .background(selectedGrade == grade ? color : Color(.systemGray5))
                                        .foregroundColor(selectedGrade == grade ? .white : .primary)
                                        .cornerRadius(6)
                                }
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }
        }
    }
}

// MARK: - 入力カード
struct InputCard<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.headline)
            }
            content
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - 計算ボタン
struct CalculateButton: View {
    @ObservedObject var viewModel: FitCalculatorViewModel

    var body: some View {
        Button(action: {
            viewModel.calculate()
        }) {
            HStack {
                Image(systemName: "function")
                Text("計算する")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.canCalculate ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(!viewModel.canCalculate)

        if let error = viewModel.errorMessage {
            Text(error)
                .font(.caption)
                .foregroundColor(.red)
                .padding(.top, 4)
        }
    }
}

// MARK: - 結果セクション
struct ResultSection: View {
    let result: FitResult

    var body: some View {
        VStack(spacing: 16) {
            // はめあい種類
            FitTypeCard(fitType: result.fitType)

            // 公差値詳細
            ToleranceDetailCard(title: "穴の公差", tolerance: result.holeTolerance, color: .blue)
            ToleranceDetailCard(title: "軸の公差", tolerance: result.shaftTolerance, color: .orange)

            // すきま/しめしろ
            ClearanceCard(result: result)

            // 図解
            FitDiagramView(result: result)
        }
    }
}

// MARK: - はめあい種類カード
struct FitTypeCard: View {
    let fitType: FitType

    var fitColor: Color {
        switch fitType {
        case .clearance: return .green
        case .transition: return .orange
        case .interference: return .red
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Circle()
                    .fill(fitColor)
                    .frame(width: 12, height: 12)
                Text(fitType.rawValue)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            Text(fitType.description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(fitColor.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - 公差詳細カード
struct ToleranceDetailCard: View {
    let title: String
    let tolerance: ToleranceResult
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text(tolerance.toleranceClass)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("上の寸法許容差")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatDeviation(tolerance.upperDeviation))
                        .font(.system(.body, design: .monospaced))
                }

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("下の寸法許容差")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(formatDeviation(tolerance.lowerDeviation))
                        .font(.system(.body, design: .monospaced))
                }
            }

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("最大寸法")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.4f mm", tolerance.maxDiameter))
                        .font(.system(.body, design: .monospaced))
                }

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("最小寸法")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.4f mm", tolerance.minDiameter))
                        .font(.system(.body, design: .monospaced))
                }
            }

            HStack {
                Text("公差幅")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(String(format: "%.4f mm (%.1f μm)", tolerance.toleranceValue, tolerance.toleranceValue * 1000))
                    .font(.system(.caption, design: .monospaced))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }

    private func formatDeviation(_ value: Double) -> String {
        if value >= 0 {
            return String(format: "+%.4f mm (+%.1f μm)", value, value * 1000)
        } else {
            return String(format: "%.4f mm (%.1f μm)", value, value * 1000)
        }
    }
}

// MARK: - すきま/しめしろカード
struct ClearanceCard: View {
    let result: FitResult

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("すきま / しめしろ")
                .font(.headline)

            Divider()

            if result.fitType == .clearance {
                HStack {
                    Text("最大すきま")
                    Spacer()
                    Text(String(format: "+%.4f mm", result.maxClearance))
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.green)
                }
                HStack {
                    Text("最小すきま")
                    Spacer()
                    Text(String(format: "+%.4f mm", result.minClearance))
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.green)
                }
            } else if result.fitType == .interference {
                HStack {
                    Text("最大しめしろ")
                    Spacer()
                    Text(String(format: "%.4f mm", result.maxInterference))
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.red)
                }
                HStack {
                    Text("最小しめしろ")
                    Spacer()
                    Text(String(format: "%.4f mm", result.minInterference))
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.red)
                }
            } else {
                HStack {
                    Text("最大すきま")
                    Spacer()
                    Text(String(format: "+%.4f mm", result.maxClearance))
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.green)
                }
                HStack {
                    Text("最大しめしろ")
                    Spacer()
                    Text(String(format: "%.4f mm", result.maxInterference))
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - 表示モード
enum DisplayMode {
    case common  // 常用する公差クラスのみ
    case all     // 全ての公差クラス
}

// MARK: - ViewModel
class FitCalculatorViewModel: ObservableObject {
    @Published var diameterText: String = ""
    @Published var displayMode: DisplayMode = .common
    @Published var selectedHoleLetter: String = "H"
    @Published var selectedHoleGrade: Int = 7
    @Published var selectedShaftLetter: String = "g"
    @Published var selectedShaftGrade: Int = 6
    @Published var fitResult: FitResult?
    @Published var showResult: Bool = false
    @Published var errorMessage: String?

    private let calculator = ToleranceCalculator()

    // 常用する穴の公差域クラス
    let commonHoleLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "JS", "J", "K", "M", "N", "P", "R", "S"]

    // 全ての穴の公差域クラス（ISO 286準拠）
    let allHoleLetters = ["A", "B", "C", "CD", "D", "E", "EF", "F", "FG", "G", "H", "JS", "J", "K", "M", "N", "P", "R", "S", "T", "U", "V", "X", "Y", "Z", "ZA", "ZB", "ZC"]

    // 常用する軸の公差域クラス
    let commonShaftLetters = ["a", "b", "c", "d", "e", "f", "g", "h", "js", "j", "k", "m", "n", "p", "r", "s"]

    // 全ての軸の公差域クラス（ISO 286準拠）
    let allShaftLetters = ["a", "b", "c", "cd", "d", "e", "ef", "f", "fg", "g", "h", "js", "j", "k", "m", "n", "p", "r", "s", "t", "u", "v", "x", "y", "z", "za", "zb", "zc"]

    // 常用するIT等級
    let commonGradesList = [5, 6, 7, 8, 9, 10, 11]

    // 全てのIT等級
    let allGradesList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18]

    var availableHoleLetters: [String] {
        displayMode == .common ? commonHoleLetters : allHoleLetters
    }

    var availableShaftLetters: [String] {
        displayMode == .common ? commonShaftLetters : allShaftLetters
    }

    var availableGrades: [Int] {
        displayMode == .common ? commonGradesList : allGradesList
    }

    var selectedHoleClass: String {
        "\(selectedHoleLetter)\(selectedHoleGrade)"
    }

    var selectedShaftClass: String {
        "\(selectedShaftLetter)\(selectedShaftGrade)"
    }

    var canCalculate: Bool {
        guard let diameter = Double(diameterText) else { return false }
        return diameter >= 1 && diameter <= 500
    }

    func calculate() {
        guard let diameter = Double(diameterText) else {
            errorMessage = "有効な数値を入力してください"
            return
        }

        guard diameter >= 1 && diameter <= 500 else {
            errorMessage = "基準寸法は1〜500mmの範囲で入力してください"
            return
        }

        if let result = calculator.calculateFit(diameter: diameter, holeClass: selectedHoleClass, shaftClass: selectedShaftClass) {
            fitResult = result
            showResult = true
            errorMessage = nil
        } else {
            errorMessage = "計算できませんでした。公差域クラスの組み合わせを確認してください。"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
