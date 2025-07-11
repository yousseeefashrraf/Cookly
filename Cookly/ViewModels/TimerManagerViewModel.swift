import SwiftUI

class TimerManagerViewModel: ObservableObject{
    let timer: Timer.TimerPublisher
    @Published var currentDate: Date
    @Published var fireDate: Date
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return formatter
    }
    
    init(currentDate: Date, fireDate: Date) {
        self.timer = Timer.publish(every: 1.0, on: .main, in: .default)
        self.currentDate = currentDate
        self.fireDate = fireDate
    }
    
    func getIntervalSinceFiring() -> DateComponents{
        let calendar = Calendar.current
        let sinceFiring = calendar.dateComponents([.hour, .minute, .second], from: fireDate, to: currentDate)
        
        return sinceFiring
    }
    
    func getTimeRemaining(cookingTimeMinutes cookingTime: Int) -> (minutes: Int, seconds: Int){
        
        let endDate = fireDate.addingTimeInterval(TimeInterval(cookingTime * 60))
        let timeRemaining = Calendar.current.dateComponents([.minute, .second], from: currentDate, to: endDate)
        
        let remainingTime = (minutes:   timeRemaining.minute ?? 0
                             , seconds: timeRemaining.second ?? 0)
        
        return remainingTime
    }
    
    func timeGonePercentage(cookingTimeMinutes cookingTime: Int) -> Double{
        
        let currentTime = getIntervalSinceFiring()
        
        guard let minutes = currentTime.minute, let seconds = currentTime.second else {
            return 0
        }
        let gone = Double(minutes * 60 + seconds)
        let total = Double(cookingTime * 60)
        let percentage = gone / total
        
        return percentage
        
    }
}
