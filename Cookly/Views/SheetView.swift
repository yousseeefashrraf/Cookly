import SwiftUI

struct CookingTextView: View {
    var width: CGFloat
    var body: some View {
        Text("Cooking")
            .font(.system(size: width * 0.33 ,design: .rounded))
            .foregroundStyle(LinearGradient(topLeadingBottomTrailingOf: [.blue, .purple]))
            .bold()
            .opacity(0.7)
    }
}

struct CountDownView: View {
    var proxy: GeometryProxy
    var width: CGFloat
    @Binding var countDown: (minutes: Int, seconds: Int)?
    @ObservedObject var timerManager: TimerManagerViewModel

    var body: some View {
        if let countDown {
            ZStack {
                HStack(spacing: 0) {
                    Text(String(format: "%02d", countDown.minutes))
                        .frame(width: width, alignment: .trailing)
                        .foregroundStyle(LinearGradient(topLeadingBottomTrailingOf: [.purple, .black, .blue]))

                    Text(":")
                        .foregroundStyle(LinearGradient(colors: [.darkGreen, .gray, .blue, .white], startPoint: .topLeading, endPoint: .bottomTrailing))

                    Text(String(format: "%02d", countDown.seconds))
                        .frame(width: width, alignment: .leading)
                        .foregroundStyle(LinearGradient(topLeadingBottomTrailingOf: [.blue, .black, .purple]))
                }
                .id("\(countDown.minutes)\(countDown.seconds)")
                .lineLimit(1)
                .font(.system(size: width / 2, design: .rounded))
                .opacity(0.7)
                .frame(width: proxy.size.width * 0.67, height: proxy.size.width * 0.67)
                .overlay {
                    Circle()
                        .stroke(.gray, lineWidth: 7)
                }

                Color(.lightGreen)
                    .frame(width: proxy.size.width * 0.67, height: proxy.size.width * 0.67)
                    .mask {
                        Circle()
                            .stroke(.gray, lineWidth: 7)
                    }

                Circle()
                    .trim(from: 0.0, to: timerManager.percentage)
                    .stroke(style: .init(lineWidth: 13, lineCap: .round))
                    .foregroundStyle(LinearGradient(colors: [.purple, .darkGreen, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: proxy.size.width * 0.67, height: proxy.size.width * 0.67)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: timerManager.percentage)
            }
            .font(.system(size: proxy.size.width * 0.15, design: .rounded))
            .position(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY)
        }
    }
}

struct CountDownControlBarView: View {
    @ObservedObject var timerManager: TimerManagerViewModel
    @Binding var isAlertPresented: Bool
    @Binding var isSheetUp: Bool
    @ObservedObject var cookViewModel: CookViewModel

    var body: some View {
        HStack(spacing: 30) {
            Image(systemName: timerManager.didTimerStop ? "play.circle" : "pause.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .opacity(0.7)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .gray, .red],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .onTapGesture {
                    withAnimation(.snappy) {
                        timerManager.didTimerStop.toggle()
                    }
                }

            Image(systemName: "minus.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .foregroundStyle(.red)
                .opacity(0.7)
                .onTapGesture {
                    isAlertPresented.toggle()
                }
        }
        .alert("Reset Timer?", isPresented: $isAlertPresented) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                withAnimation(.snappy) {
                    timerManager.timer.connect().cancel()
                    cookViewModel.deleteTimer()
                    isSheetUp = false
                }
            }
        } message: {
            Text("This will reset the current countdown. Are you sure you want to proceed?")
        }
    }
}

struct SheetViewStaticHeader: View {
    var screenWidth: CGFloat
    @ObservedObject var cookViewModel: CookViewModel
    @State private var whichCircleToAnimate = 0

    private let cookingTimer = Timer.publish(every: 0.3, on: .current, in: .default).autoconnect()

    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .bottom, spacing: 10) {
                CookingTextView(width: screenWidth)
                    .frame(width: screenWidth * 1.3, height: 50)

                HStack(alignment: .center, spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(
                                LinearGradient(
                                    topLeadingBottomTrailingOf: [.blue, .purple]
                                )
                            )
                            .frame(width: 10, height: 10)
                            .opacity(0.7)
                            .offset(y: whichCircleToAnimate == index ? -4 : 0)
                    }
                }
            }
            .frame(width: screenWidth, alignment: .bottom)
            .padding(.top, -7)

            Image("kitchen")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 2)
                .scaleEffect(
                    cookViewModel.timerManager?.didTimerStop == true ? 1.2 : 1.0
                )
        }
        .padding(.top, 50)
        .onReceive(cookingTimer) { _ in
            withAnimation(.spring(response: 0.5)) {
                if cookViewModel.timerManager?.didTimerStop == false {
                    whichCircleToAnimate = (whichCircleToAnimate + 1) % 3
                } else {
                    whichCircleToAnimate = -1
                }
            }
        }
    }
}


struct SubscriberView: View {
    @ObservedObject var timerManager: TimerManagerViewModel
    @ObservedObject var cookViewModel: CookViewModel
    @Binding var countDown: (minutes: Int, seconds: Int)?
    var cookingTime: Int

    var body: some View {
        VStack {} // Placeholder
            .onReceive(timerManager.timer) { date in
                timerManager.currentDate = date

                
                    timerManager.percentage = timerManager.updatePercentage(cookingTimeMinutes: cookingTime)
                

                countDown = timerManager.getTimeRemaining()
                
                let time = timerManager.getTimeRemaining()
                if time.minutes * 60 + time.seconds <= 0 {
                    timerManager.timer.connect().cancel()
                    cookViewModel.deleteTimer()
                    countDown = nil
                }
                
                   
                
                    
                    
            }
    }
}

struct SheetView: View {
    @ObservedObject var cookViewModel: CookViewModel
    @ObservedObject var timerManager: TimerManagerViewModel
    @Binding var countDown: (minutes: Int, seconds: Int)?
    @Binding var screenWidth: CGFloat
    @Binding var isSheetUp: Bool
    @State var isAlertPresented = false
    let imageUrl: String
    var cookingTime: Int

    var body: some View {
        ZStack {
            LinearGradient(topLeadingBottomTrailingOf: [.purple, .white, .white, .white, .blue])
                .opacity(0.3)
                .ignoresSafeArea()
                .blur(radius: 100)

            VStack(spacing: 0) {
                SheetViewStaticHeader(screenWidth: screenWidth, cookViewModel: cookViewModel)

                if countDown != nil {
                    GeometryReader { proxy in
                        let width = proxy.size.width * 0.3

                        CountDownView(
                            proxy: proxy,
                            width: width,
                            countDown: $countDown,
                            timerManager: timerManager
                        )
                    }
                    .scaleEffect(x: timerManager.didTimerStop ? 0.95 : 1, y: timerManager.didTimerStop ? 0.95 : 1)
                    .padding(.top, 10)

                    CountDownControlBarView(
                        timerManager: timerManager,
                        isAlertPresented: $isAlertPresented,
                        isSheetUp: $isSheetUp,
                        cookViewModel: cookViewModel
                    )
                }

                Spacer()
            }
        }
        .onAppear {
            if let count = countDown, count.minutes == 0 && count.seconds == 0 {
                cookViewModel.startCookingTimer(startingDate: .now, cookingTime: cookingTime)
                _ = cookViewModel.timerManager?.timer.connect()
                countDown = cookViewModel.timerManager?.getTimeRemaining()
            }
        }
    }
}
