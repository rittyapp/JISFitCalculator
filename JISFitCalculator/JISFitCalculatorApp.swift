import SwiftUI

@main
struct JISFitCalculatorApp: App {
    @State private var isLoading = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoading {
                    LoadingView()
                        .transition(.opacity)
                } else {
                    ContentView()
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.5), value: isLoading)
            .onAppear {
                // 2秒後にメイン画面に遷移
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        }
    }
}
