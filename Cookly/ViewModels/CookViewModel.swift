import SwiftUI

class CookViewModel: ObservableObject{
    @Published var isShown = false
    @Published var timerManager: TimerManagerViewModel? = nil
    @Published var invalidated = false
    
    init(){
        
    }
    
    func ShowIcon(after: CGFloat){
        Timer.scheduledTimer(withTimeInterval: after, repeats: false) { [weak self] t in
            withAnimation(.spring) {
                if !(self?.invalidated ?? true) {
                    self?.isShown = true
                }
               
            }
            
        }
       
    }
    
    
    func deleteTimer(){
        timerManager = nil
        isShown = false
    }
    
    func startCookingTimer(startingDate date: Date, cookingTime: Int){
        DispatchQueue.main.async{ [weak self] in
            self?.timerManager = TimerManagerViewModel(currentDate: .now, fireDate: date, cookingTime: cookingTime)
            self?.timerManager?.timer.connect()
        }

        }
    }
