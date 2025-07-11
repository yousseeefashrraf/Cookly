import SwiftUI

struct TimerIconView: View{
    @Binding var isSheetUp: Bool
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
                        HapticFeedbackManager.manager.impact(style: .light)
                        }
                   

            } animation: { _ in
                    .bouncy.delay(1)
            }
        
    }
}


class BubbleViewModel: ObservableObject{
    @Published var offsetPoint: CGPoint = .init(x: 0, y: 0)
    @Published var isDrag = false
    var width: CGFloat = 0.0
    var screenSize: CGSize = CGSize.zero

    init(offsetPoint: CGPoint, isDrag: Bool = false, width: CGFloat, screenSize: CGSize ) {
        self.offsetPoint = offsetPoint
        self.isDrag = isDrag
        self.width = width
        self.screenSize = screenSize

    }
    func updatingGesture(value: DragGesture.Value, state: inout Int, transaction: inout Transaction){
        
        if(abs(value.location.x)  < screenSize.width + width) && (value.location.x < 0){
            withAnimation(.easeIn(duration: 0.2)){
                offsetPoint.x = value.location.x
            }
           
            
        }
        
        if(abs(value.location.y)  < screenSize.height + width ) && (value.location.y + width < 40){
            
            withAnimation(.easeIn(duration: 0.2)){
                offsetPoint.y = value.location.y
            }
           
            
            
        }
    }
    
    func endGestureAction(){
        withAnimation(.bouncy) {
            isDrag = false
        }
        if(abs(offsetPoint.x)  <
           screenSize.width/2) {
            withAnimation(.bouncy) {
                offsetPoint.x = 0
            }

            
            
        } else {
            withAnimation(.bouncy) {
                offsetPoint.x = -(screenSize.width - width - 20)
            }
            
        }
    }
}



struct BubbleView: View{
    var width = 65.0
    @Binding var isSheetUp: Bool
    @ObservedObject var cookViewModel: CookViewModel //this should be observed object
    @StateObject var bubbleViewModel: BubbleViewModel
    var screenSize: CGSize
    
    init(width: Double = 65.0, isSheetUp: Binding<Bool>, offsetPoint: CGPoint, cookViewModel: CookViewModel, isDrag: Bool = false, bubbleViewModel: BubbleViewModel, screenSize: CGSize) {
        self.width = width
        self._isSheetUp = isSheetUp
        self.cookViewModel = cookViewModel
        self.screenSize = screenSize

        self._bubbleViewModel = StateObject(wrappedValue: BubbleViewModel(offsetPoint: offsetPoint, isDrag: isDrag, width: width, screenSize: screenSize))
    }
    
    var body: some View{
        let isDrag = bubbleViewModel.isDrag
        let offsetPoint = bubbleViewModel.offsetPoint
        if (cookViewModel.isShown) {
            VStack{
                TimerIconView(isSheetUp: $isSheetUp, width: width)
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





#Preview {
    
}
