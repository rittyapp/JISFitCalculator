import SwiftUI

struct LoadingView: View {
    @State private var progress: CGFloat = 0
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            // 背景グラデーション
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.97, green: 0.98, blue: 0.99),
                    Color(red: 0.95, green: 0.96, blue: 0.97),
                    Color(red: 0.90, green: 0.92, blue: 0.94)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // メインコンテンツカード
                    VStack(spacing: 24) {
                        // タイトル
                        TitleSection()

                        // 技術図面
                        TechnicalDrawing()
                            .frame(height: 200)

                        // ローディングアニメーション
                        LoadingAnimation(progress: $progress, isAnimating: $isAnimating)

                        // 規格情報
                        StandardsInfo()
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                    .padding(.horizontal, 20)
                    .padding(.top, 40)

                    // フッター
                    Text("© 2025 JIS Fit Calculator")
                        .font(.system(size: 11))
                        .foregroundColor(Color(red: 0.6, green: 0.65, blue: 0.7))
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            startLoadingAnimation()
        }
    }

    private func startLoadingAnimation() {
        isAnimating = true
        withAnimation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            progress = 1.0
        }
    }
}

// MARK: - タイトルセクション
struct TitleSection: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("JIS Fit Calculator")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(red: 0.2, green: 0.25, blue: 0.3))
                .tracking(-0.5)

            Text("機械設計公差計算ツール")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.5))
                .tracking(1)

            Text("JIS B 0401 / ISO 286")
                .font(.system(size: 11))
                .foregroundColor(Color(red: 0.6, green: 0.65, blue: 0.7))
                .padding(.top, 2)
        }
    }
}

// MARK: - 技術図面
struct TechnicalDrawing: View {
    var body: some View {
        Canvas { context, size in
            let width = size.width
            let height = size.height

            // グリッド背景
            drawGrid(context: context, size: size)

            // 軸（左側）
            drawShaft(context: context, size: size)

            // 穴（右側）
            drawHole(context: context, size: size)

            // 組立矢印
            drawAssemblyArrow(context: context, size: size)

            // はめあい種類表示
            drawFitTypeLabel(context: context, size: size)

            // タイトルフレーム
            drawTitleFrame(context: context, size: size)
        }
        .background(Color(red: 0.98, green: 0.98, blue: 0.99))
        .cornerRadius(8)
    }

    private func drawGrid(context: GraphicsContext, size: CGSize) {
        let gridColor = Color(red: 0.9, green: 0.92, blue: 0.94)

        // 細かいグリッド
        for i in stride(from: 0, to: size.width, by: 10) {
            var path = Path()
            path.move(to: CGPoint(x: i, y: 0))
            path.addLine(to: CGPoint(x: i, y: size.height))
            context.stroke(path, with: .color(gridColor.opacity(0.5)), lineWidth: 0.3)
        }
        for i in stride(from: 0, to: size.height, by: 10) {
            var path = Path()
            path.move(to: CGPoint(x: 0, y: i))
            path.addLine(to: CGPoint(x: size.width, y: i))
            context.stroke(path, with: .color(gridColor.opacity(0.5)), lineWidth: 0.3)
        }
    }

    private func drawShaft(context: GraphicsContext, size: CGSize) {
        let shaftColor = Color(red: 0.8, green: 0.84, blue: 0.88)
        let strokeColor = Color(red: 0.2, green: 0.25, blue: 0.33)

        let centerY = size.height * 0.5
        let shaftHeight: CGFloat = 50
        let shaftWidth: CGFloat = 100
        let startX: CGFloat = size.width * 0.1

        // 軸本体
        let shaftRect = CGRect(x: startX, y: centerY - shaftHeight/2, width: shaftWidth, height: shaftHeight)
        context.fill(Path(shaftRect), with: .color(shaftColor))
        context.stroke(Path(shaftRect), with: .color(strokeColor), lineWidth: 1.5)

        // 中心線
        var centerLine = Path()
        centerLine.move(to: CGPoint(x: startX - 15, y: centerY))
        centerLine.addLine(to: CGPoint(x: startX + shaftWidth + 20, y: centerY))
        context.stroke(centerLine, with: .color(strokeColor), style: StrokeStyle(lineWidth: 0.8, dash: [8, 3, 2, 3]))

        // 寸法線
        let dimX = startX + shaftWidth + 8
        var dimLine = Path()
        dimLine.move(to: CGPoint(x: dimX, y: centerY - shaftHeight/2))
        dimLine.addLine(to: CGPoint(x: dimX, y: centerY + shaftHeight/2))
        context.stroke(dimLine, with: .color(strokeColor), lineWidth: 1)

        // g6ラベル
        context.draw(
            Text("g6").font(.system(size: 12, weight: .bold)).foregroundColor(Color(red: 0.2, green: 0.25, blue: 0.33)),
            at: CGPoint(x: dimX + 15, y: centerY)
        )
    }

    private func drawHole(context: GraphicsContext, size: CGSize) {
        let outerColor = Color(red: 0.58, green: 0.64, blue: 0.72)
        let strokeColor = Color(red: 0.2, green: 0.25, blue: 0.33)

        let centerY = size.height * 0.5
        let outerHeight: CGFloat = 70
        let outerWidth: CGFloat = 50
        let innerHeight: CGFloat = 50
        let startX: CGFloat = size.width * 0.6

        // 外側ボディ
        let outerRect = CGRect(x: startX, y: centerY - outerHeight/2, width: outerWidth, height: outerHeight)
        context.fill(Path(outerRect), with: .color(outerColor))
        context.stroke(Path(outerRect), with: .color(strokeColor), lineWidth: 1.5)

        // 内側穴
        let innerRect = CGRect(x: startX, y: centerY - innerHeight/2, width: outerWidth, height: innerHeight)
        context.fill(Path(innerRect), with: .color(.white))
        context.stroke(Path(innerRect), with: .color(strokeColor), lineWidth: 1.5)

        // ハッチング（上部）
        let hatchColor = Color(red: 0.28, green: 0.35, blue: 0.42)
        for i in stride(from: 0, to: 60, by: 5) {
            var hatch = Path()
            hatch.move(to: CGPoint(x: startX + CGFloat(i), y: centerY - outerHeight/2))
            hatch.addLine(to: CGPoint(x: startX + CGFloat(i) + 10, y: centerY - innerHeight/2))
            context.stroke(hatch, with: .color(hatchColor.opacity(0.5)), lineWidth: 0.5)
        }

        // ハッチング（下部）
        for i in stride(from: 0, to: 60, by: 5) {
            var hatch = Path()
            hatch.move(to: CGPoint(x: startX + CGFloat(i), y: centerY + innerHeight/2))
            hatch.addLine(to: CGPoint(x: startX + CGFloat(i) + 10, y: centerY + outerHeight/2))
            context.stroke(hatch, with: .color(hatchColor.opacity(0.5)), lineWidth: 0.5)
        }

        // 中心線
        var centerLine = Path()
        centerLine.move(to: CGPoint(x: startX - 20, y: centerY))
        centerLine.addLine(to: CGPoint(x: startX + outerWidth + 15, y: centerY))
        context.stroke(centerLine, with: .color(strokeColor), style: StrokeStyle(lineWidth: 0.8, dash: [8, 3, 2, 3]))

        // 寸法線
        let dimX = startX - 8
        var dimLine = Path()
        dimLine.move(to: CGPoint(x: dimX, y: centerY - innerHeight/2))
        dimLine.addLine(to: CGPoint(x: dimX, y: centerY + innerHeight/2))
        context.stroke(dimLine, with: .color(strokeColor), lineWidth: 1)

        // H7ラベル
        context.draw(
            Text("H7").font(.system(size: 12, weight: .bold)).foregroundColor(Color(red: 0.2, green: 0.25, blue: 0.33)),
            at: CGPoint(x: dimX - 15, y: centerY)
        )
    }

    private func drawAssemblyArrow(context: GraphicsContext, size: CGSize) {
        let arrowColor = Color(red: 0.15, green: 0.39, blue: 0.92)
        let centerY = size.height * 0.5 + 10
        let startX = size.width * 0.35
        let endX = size.width * 0.52

        // 矢印の線
        var arrow = Path()
        arrow.move(to: CGPoint(x: startX, y: centerY))
        arrow.addLine(to: CGPoint(x: endX, y: centerY))
        context.stroke(arrow, with: .color(arrowColor), lineWidth: 2.5)

        // 矢印の先端
        var arrowHead = Path()
        arrowHead.move(to: CGPoint(x: endX + 8, y: centerY))
        arrowHead.addLine(to: CGPoint(x: endX, y: centerY - 5))
        arrowHead.addLine(to: CGPoint(x: endX, y: centerY + 5))
        arrowHead.closeSubpath()
        context.fill(arrowHead, with: .color(arrowColor))
    }

    private func drawFitTypeLabel(context: GraphicsContext, size: CGSize) {
        let bgColor = Color(red: 0.94, green: 0.96, blue: 1.0)
        let borderColor = Color(red: 0.15, green: 0.39, blue: 0.92)

        let labelWidth: CGFloat = 100
        let labelHeight: CGFloat = 35
        let x = size.width * 0.5 - labelWidth/2
        let y = size.height * 0.82

        let labelRect = RoundedRectangle(cornerRadius: 4)
        let rect = CGRect(x: x, y: y, width: labelWidth, height: labelHeight)

        context.fill(Path(roundedRect: rect, cornerRadius: 4), with: .color(bgColor))
        context.stroke(Path(roundedRect: rect, cornerRadius: 4), with: .color(borderColor), lineWidth: 1)

        context.draw(
            Text("すきまばめ").font(.system(size: 10, weight: .semibold)).foregroundColor(Color(red: 0.12, green: 0.25, blue: 0.55)),
            at: CGPoint(x: x + labelWidth/2, y: y + 12)
        )
        context.draw(
            Text("Clearance Fit").font(.system(size: 8)).foregroundColor(Color(red: 0.23, green: 0.51, blue: 0.98)),
            at: CGPoint(x: x + labelWidth/2, y: y + 25)
        )
    }

    private func drawTitleFrame(context: GraphicsContext, size: CGSize) {
        let strokeColor = Color(red: 0.2, green: 0.25, blue: 0.33)

        let frameWidth: CGFloat = 90
        let frameHeight: CGFloat = 50
        let x = size.width - frameWidth - 10
        let y: CGFloat = 10

        let frameRect = CGRect(x: x, y: y, width: frameWidth, height: frameHeight)
        context.fill(Path(frameRect), with: .color(.white))
        context.stroke(Path(frameRect), with: .color(strokeColor), lineWidth: 1)

        // 区切り線
        var divider = Path()
        divider.move(to: CGPoint(x: x, y: y + 18))
        divider.addLine(to: CGPoint(x: x + frameWidth, y: y + 18))
        context.stroke(divider, with: .color(strokeColor), lineWidth: 0.5)

        context.draw(
            Text("はめあい公差").font(.system(size: 9, weight: .semibold)).foregroundColor(Color(red: 0.2, green: 0.25, blue: 0.33)),
            at: CGPoint(x: x + frameWidth/2, y: y + 10)
        )
        context.draw(
            Text("H7/g6").font(.system(size: 10)).foregroundColor(Color(red: 0.28, green: 0.35, blue: 0.42)),
            at: CGPoint(x: x + 25, y: y + 30)
        )
        context.draw(
            Text("軸穴嵌合").font(.system(size: 9)).foregroundColor(Color(red: 0.28, green: 0.35, blue: 0.42)),
            at: CGPoint(x: x + 25, y: y + 42)
        )
    }
}

// MARK: - ローディングアニメーション
struct LoadingAnimation: View {
    @Binding var progress: CGFloat
    @Binding var isAnimating: Bool

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("計算準備中...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.3, green: 0.35, blue: 0.4))
                Spacer()
                Text("Loading")
                    .font(.system(size: 11))
                    .foregroundColor(Color(red: 0.6, green: 0.65, blue: 0.7))
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // 背景
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.9, green: 0.92, blue: 0.94))

                    // プログレス
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.23, green: 0.51, blue: 0.98),
                                    Color(red: 0.15, green: 0.39, blue: 0.92)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * (0.3 + progress * 0.5))
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: progress)
                }
            }
            .frame(height: 8)
        }
    }
}

// MARK: - 規格情報
struct StandardsInfo: View {
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .padding(.bottom, 16)

            HStack(spacing: 0) {
                InfoItem(label: "準拠規格", value: "JIS B 0401")
                InfoItem(label: "国際規格", value: "ISO 286")
                InfoItem(label: "精度等級", value: "IT01~IT18")
            }
        }
    }
}

struct InfoItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(Color(red: 0.6, green: 0.65, blue: 0.7))
            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(red: 0.28, green: 0.35, blue: 0.42))
        }
        .frame(maxWidth: .infinity)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
