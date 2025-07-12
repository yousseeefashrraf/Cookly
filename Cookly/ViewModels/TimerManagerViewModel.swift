import SwiftUI

class TimerManagerViewModel: ObservableObject{
    let timer: Timer.TimerPublisher
    var currentDate: Date
    var fireDate: Date
    @Published var percentage: CGFloat
    var endDate: Date
    var pauseDate: Date?
    @Published var didTimerStop: Bool
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return formatter
    }
    

    init(currentDate: Date, fireDate: Date, cookingTime: Int) {
        self.timer = Timer.publish(every: 1.0, on: .current, in: .default)
        self.currentDate = currentDate
        self.fireDate = fireDate
        self.endDate = fireDate.addingTimeInterval(TimeInterval(cookingTime * 60))
        self.didTimerStop = false
        self.pauseDate = nil
        self.didTimerStop = false
        self.percentage = 0

    }
    
    func delayEndTime(){
        if let pauseDate{
            let pausedDuration = Date().timeIntervalSince(pauseDate)
            endDate = endDate.addingTimeInterval(pausedDuration)
            self.pauseDate = nil
            currentDate = .now
        }
    }
    
    func getIntervalSinceFiring() -> DateComponents{
        let calendar = Calendar.current
        let sinceFiring = calendar.dateComponents([.hour, .minute, .second], from: fireDate, to: currentDate)
        
        return sinceFiring
    }
    
    func getTimeRemaining() -> (minutes: Int, seconds: Int) {
        
        if didTimerStop {
            if pauseDate == nil {
                pauseDate = .now
            } else {
                delayEndTime()
                pauseDate = .now
            }
        } else {
            pauseDate = nil
        }

        let timeRemaining = Calendar.current.dateComponents([.minute, .second], from: currentDate, to: endDate)
        return (minutes: timeRemaining.minute ?? 0, seconds: timeRemaining.second ?? 0)
    }

    
    func updatePercentage(cookingTimeMinutes cookingTime: Int) -> Double{
        
        let currentTime = getTimeRemaining()
        
        let left = Double(currentTime.minutes * 60 + currentTime.seconds)
        let total = Double(cookingTime * 60)
        let percentage = left / total
        self.percentage = percentage
        return 1-percentage
    }
}
