import SwiftUI

struct TimerIconView: View{
    @Binding var isSheetUp: Bool
    @ObservedObject var cookViewModel: CookViewModel
    @ObservedObject var recipesViewModel: RecipesViewModel

    var width: CGFloat
    var body: some View{
        let gradient =
        LinearGradient(topLeadingBottomTrailingOf: [.red, .gray, .blue])
        
        let frames = [
            
                       1 :
                        LinearGradient(topLeadingBottomTrailingOf: [.red, .gray, .blue]),
                      
                      2 :  LinearGradient(topLeadingBottomTrailingOf: [.blue, .gray, .red]),
                      
                      3 : LinearGradient(topLeadingBottomTrailingOf: [.black, .gray, .black])
        ]
        
            PhaseAnimator(frames.keys) { eq in
                Image(systemName: "timer")
                    .resizable()
                    .scaledToFit()
                    .padding(15)
                    .background(.white)
                    .clipShape(.circle)
                    .overlay {
                        Circle()
                            .fill(frames[eq] ?? gradient)
                            .frame(width: width + 5)
                            .mask {
                                Circle().stroke()
                                    .padding(2)
                            }
                    }
                    .foregroundStyle(eq == 1 ? .gray : .black)
                    .onTapGesture {
                        isSheetUp = true
                        if(cookViewModel.timerManager == nil){
                            cookViewModel.startCookingTimer(startingDate: .now, cookingTime: recipesViewModel.currentRecipe?.cookTimeMinutes ?? 0)
                        }
                       
                        
                        HapticFeedbackManager.manager.impact(style: .light)
                        }
                   

            } animation: { _ in
                    .bouncy.delay(1)
            }
        
    }
}



struct BubbleView: View{
    var width = 65.0
    @Binding var isSheetUp: Bool
    @ObservedObject var cookViewModel: CookViewModel //this should be observed object
    @ObservedObject var recipesViewModel: RecipesViewModel //this should be observed object

    @StateObject var bubbleViewModel: BubbleViewModel
    var screenSize: CGSize
    
    init(width: Double = 65.0, isSheetUp: Binding<Bool>, cookViewModel: CookViewModel, isDrag: Bool = false, screenSize: CGSize, recipesViewModel: RecipesViewModel) {
        self.width = width
        self._isSheetUp = isSheetUp
        self.cookViewModel = cookViewModel
        self.screenSize = screenSize
        self.recipesViewModel = recipesViewModel
        self._bubbleViewModel = StateObject(wrappedValue: BubbleViewModel(isDrag: isDrag, width: width, screenSize: screenSize))
    }
    
    var body: some View{
        let isDrag = bubbleViewModel.isDrag
        let offsetPoint = bubbleViewModel.offsetPoint
        if (cookViewModel.isShown) {
            VStack{
                TimerIconView(isSheetUp: $isSheetUp, cookViewModel: cookViewModel, recipesViewModel: recipesViewModel, width: width)
            }
            
            .scaleEffect(x: isDrag ? 1.2 : 1, y: isDrag ? 1.2 : 1)
            .frame(width: width)
            .padding(10)
            .offset(x: offsetPoint.x, y: offsetPoint.y)
            .gesture (
                DragGesture()
                    .onChanged({ gesture in
                        withAnimation(.bouncy) {
                            bubbleViewModel.isDrag = true
                        }
                       
                    })
                    
                    .updating(.init(initialValue: 0)){ value, state, transaction in
                        bubbleViewModel.updatingGesture(value: value, state: &state, transaction: &transaction)
                    }
                    .onEnded({ _ in bubbleViewModel.endGestureAction() })
            )
            
        }
    }
}



#Preview {
    
}




