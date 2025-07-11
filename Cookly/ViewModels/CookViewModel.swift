import SwiftUI

class CookViewModel: ObservableObject{
    @Published var isShown = false
    @Published var timerManager: TimerManagerViewModel? = nil

    
    init(){
        ShowIcon(after: 5.0)
    }
    
    func ShowIcon(after: CGFloat){
        Timer.scheduledTimer(withTimeInterval: after, repeats: false) { [weak self] t in
            withAnimation(.spring) {
                self?.isShown = true
            }
            
        }
    }
    
    func startCookingTimer(startingDate date: Date){
        timerManager = TimerManagerViewModel(currentDate: .now, fireDate: date)
        }
    }
