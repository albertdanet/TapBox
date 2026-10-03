import SwiftUI

struct ContentView: View {
    enum Screen { case menu, game, result }

    @State private var screen: Screen = .menu
    @State private var score = 0
    @State private var best = UserDefaults.standard.integer(forKey: "bestScore")
    @State private var timeLeft = 30
    @State private var targetX: CGFloat = 0.5
    @State private var targetY: CGFloat = 0.5
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.03, green: 0.04, blue: 0.14),
                         Color(red: 0.10, green: 0.04, blue: 0.25)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            switch screen {
            case .menu:
                menu
            case .game:
                game
            case .result:
                result
            }
        }
        .preferredColorScheme(.dark)
        .onDisappear { timer?.invalidate() }
    }

    private var menu: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "square.fill")
                .font(.system(size: 72))
                .foregroundStyle(.blue)
                .shadow(color: .blue.opacity(0.7), radius: 18)

            Text("TapBox")
                .font(.system(size: 46, weight: .black, design: .rounded))

            Text("Нажимай на квадрат и набирай очки!")
                .foregroundStyle(.white.opacity(0.65))

            Button {
                startGame()
            } label: {
                Text("ИГРАТЬ")
                    .font(.headline.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 34)

            Text("Рекорд: \(best)")
                .font(.headline)
                .foregroundStyle(.white.opacity(0.8))
            Spacer()
        }
        .padding()
    }

    private var game: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    HStack {
                        Text("Счёт: \(score)")
                        Spacer()
                        Text("Время: \(timeLeft)")
                    }
                    .font(.headline.bold())
                    .padding(.horizontal)
                    .padding(.top, 12)
                    Spacer()
                }

                Button {
                    score += 1
                    moveTarget()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(colors: [.cyan, .blue],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing)
                        )
                        .frame(width: 68, height: 68)
                        .shadow(color: .blue.opacity(0.75), radius: 14)
                }
                .position(
                    x: max(45, min(geo.size.width - 45, geo.size.width * targetX)),
                    y: max(120, min(geo.size.height - 70, geo.size.height * targetY))
                )
                .animation(.spring(response: 0.22, dampingFraction: 0.7), value: targetX)
            }
        }
    }

    private var result: some View {
        VStack(spacing: 22) {
            Spacer()
            Image(systemName: "trophy.fill")
                .font(.system(size: 70))
                .foregroundStyle(.yellow)

            Text("Время вышло!")
                .font(.largeTitle.bold())

            Text("Счёт: \(score)")
                .font(.system(size: 40, weight: .black, design: .rounded))

            Text("Рекорд: \(best)")
                .foregroundStyle(.white.opacity(0.7))

            Button {
                startGame()
            } label: {
                Text("ИГРАТЬ СНОВА")
                    .font(.headline.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 34)

            Button {
                screen = .menu
            } label: {
                Text("ГЛАВНОЕ МЕНЮ")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 34)
            Spacer()
        }
        .padding()
    }

    private func startGame() {
        timer?.invalidate()
        score = 0
        timeLeft = 30
        moveTarget()
        screen = .game

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeLeft > 1 {
                timeLeft -= 1
            } else {
                timer?.invalidate()
                if score > best {
                    best = score
                    UserDefaults.standard.set(score, forKey: "bestScore")
                }
                screen = .result
            }
        }
    }

    private func moveTarget() {
        targetX = CGFloat.random(in: 0.12...0.88)
        targetY = CGFloat.random(in: 0.20...0.82)
    }
}
