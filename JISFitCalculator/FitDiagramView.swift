import SwiftUI

struct FitDiagramView: View {
    let result: FitResult

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("はめあい図解")
                .font(.headline)

            Divider()

            GeometryReader { geometry in
                ZStack {
                    // 背景グリッド
                    GridBackground()

                    // 図解本体
                    DiagramContent(result: result, width: geometry.size.width)
                }
            }
            .frame(height: 280)

            // 凡例
            LegendView()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// MARK: - グリッド背景
struct GridBackground: View {
    var body: some View {
        Canvas { context, size in
            // 横線
            for i in 0...10 {
                let y = CGFloat(i) * size.height / 10
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(.gray.opacity(0.2)), lineWidth: 0.5)
            }
        }
    }
}

// MARK: - 図解コンテンツ
struct DiagramContent: View {
    let result: FitResult
    let width: CGFloat

    // スケール計算用の最大値
    var maxDeviation: Double {
        let values = [
            abs(result.holeTolerance.upperDeviation),
            abs(result.holeTolerance.lowerDeviation),
            abs(result.shaftTolerance.upperDeviation),
            abs(result.shaftTolerance.lowerDeviation)
        ]
        return max(values.max() ?? 0.1, 0.01) * 1.5
    }

    func yPosition(for deviation: Double, height: CGFloat) -> CGFloat {
        let centerY = height / 2
        let scale = (height * 0.4) / maxDeviation
        return centerY - CGFloat(deviation) * scale
    }

    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let centerX = width / 2
            let holeX = centerX - 60
            let shaftX = centerX + 60
            let barWidth: CGFloat = 40

            ZStack {
                // 基準線（ゼロライン）
                ZeroLine(height: height, width: width)

                // 穴の公差域
                ToleranceBar(
                    upperDeviation: result.holeTolerance.upperDeviation,
                    lowerDeviation: result.holeTolerance.lowerDeviation,
                    maxDeviation: maxDeviation,
                    centerX: holeX,
                    barWidth: barWidth,
                    height: height,
                    color: .blue,
                    label: result.holeTolerance.toleranceClass,
                    isHole: true
                )

                // 軸の公差域
                ToleranceBar(
                    upperDeviation: result.shaftTolerance.upperDeviation,
                    lowerDeviation: result.shaftTolerance.lowerDeviation,
                    maxDeviation: maxDeviation,
                    centerX: shaftX,
                    barWidth: barWidth,
                    height: height,
                    color: .orange,
                    label: result.shaftTolerance.toleranceClass,
                    isHole: false
                )

                // 基準寸法表示
                VStack {
                    Spacer()
                    Text("基準寸法: \(String(format: "%.2f", result.holeTolerance.nominalDiameter)) mm")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)
                }

                // ラベル
                VStack {
                    HStack(spacing: 40) {
                        Text("穴")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        Text("軸")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                    .padding(.top, 8)
                    Spacer()
                }
            }
        }
    }
}

// MARK: - ゼロライン
struct ZeroLine: View {
    let height: CGFloat
    let width: CGFloat

    var body: some View {
        ZStack {
            // ゼロライン
            Path { path in
                path.move(to: CGPoint(x: 20, y: height / 2))
                path.addLine(to: CGPoint(x: width - 20, y: height / 2))
            }
            .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [5, 3]))

            // ゼロラベル
            HStack {
                Text("0")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.leading, 4)
            .offset(y: 0)
        }
    }
}

// MARK: - 公差バー
struct ToleranceBar: View {
    let upperDeviation: Double
    let lowerDeviation: Double
    let maxDeviation: Double
    let centerX: CGFloat
    let barWidth: CGFloat
    let height: CGFloat
    let color: Color
    let label: String
    let isHole: Bool

    var upperY: CGFloat {
        let centerY = height / 2
        let scale = (height * 0.4) / maxDeviation
        return centerY - CGFloat(upperDeviation) * scale
    }

    var lowerY: CGFloat {
        let centerY = height / 2
        let scale = (height * 0.4) / maxDeviation
        return centerY - CGFloat(lowerDeviation) * scale
    }

    var barHeight: CGFloat {
        return abs(lowerY - upperY)
    }

    var body: some View {
        ZStack {
            // 公差域の塗りつぶし
            Rectangle()
                .fill(color.opacity(0.3))
                .frame(width: barWidth, height: max(barHeight, 2))
                .position(x: centerX, y: (upperY + lowerY) / 2)

            // 上限線
            Path { path in
                path.move(to: CGPoint(x: centerX - barWidth/2 - 5, y: upperY))
                path.addLine(to: CGPoint(x: centerX + barWidth/2 + 5, y: upperY))
            }
            .stroke(color, lineWidth: 2)

            // 下限線
            Path { path in
                path.move(to: CGPoint(x: centerX - barWidth/2 - 5, y: lowerY))
                path.addLine(to: CGPoint(x: centerX + barWidth/2 + 5, y: lowerY))
            }
            .stroke(color, lineWidth: 2)

            // 側面線（穴または軸の形状を示す）
            if isHole {
                // 穴：外側に線
                Path { path in
                    path.move(to: CGPoint(x: centerX - barWidth/2, y: upperY))
                    path.addLine(to: CGPoint(x: centerX - barWidth/2, y: lowerY))
                }
                .stroke(color, lineWidth: 2)

                Path { path in
                    path.move(to: CGPoint(x: centerX + barWidth/2, y: upperY))
                    path.addLine(to: CGPoint(x: centerX + barWidth/2, y: lowerY))
                }
                .stroke(color, lineWidth: 2)
            } else {
                // 軸：内側を塗りつぶし
                Rectangle()
                    .fill(color.opacity(0.5))
                    .frame(width: barWidth * 0.6, height: max(barHeight, 2))
                    .position(x: centerX, y: (upperY + lowerY) / 2)
            }

            // 上の寸法許容差ラベル
            Text(formatDeviation(upperDeviation))
                .font(.system(size: 9, design: .monospaced))
                .foregroundColor(color)
                .position(x: centerX + barWidth/2 + 35, y: upperY)

            // 下の寸法許容差ラベル
            Text(formatDeviation(lowerDeviation))
                .font(.system(size: 9, design: .monospaced))
                .foregroundColor(color)
                .position(x: centerX + barWidth/2 + 35, y: lowerY)

            // 公差域クラスラベル
            Text(label)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(color)
                .position(x: centerX, y: min(upperY, lowerY) - 15)
        }
    }

    private func formatDeviation(_ value: Double) -> String {
        let micrometers = value * 1000
        if value >= 0 {
            return String(format: "+%.0fμm", micrometers)
        } else {
            return String(format: "%.0fμm", micrometers)
        }
    }
}

// MARK: - 凡例
struct LegendView: View {
    var body: some View {
        HStack(spacing: 20) {
            LegendItem(color: .blue, label: "穴の公差域")
            LegendItem(color: .orange, label: "軸の公差域")
            LegendItem(color: .gray, label: "基準線(0)")
        }
        .font(.caption2)
    }
}

struct LegendItem: View {
    let color: Color
    let label: String

    var body: some View {
        HStack(spacing: 4) {
            Rectangle()
                .fill(color.opacity(0.5))
                .frame(width: 12, height: 12)
                .overlay(
                    Rectangle()
                        .stroke(color, lineWidth: 1)
                )
            Text(label)
                .foregroundColor(.secondary)
        }
    }
}

struct FitDiagramView_Previews: PreviewProvider {
    static var previews: some View {
        let calculator = ToleranceCalculator()
        let result = calculator.calculateFit(diameter: 50, holeClass: "H7", shaftClass: "g6")!

        FitDiagramView(result: result)
            .padding()
    }
}
