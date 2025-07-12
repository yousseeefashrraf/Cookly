import SwiftUI

class BubbleViewModel: ObservableObject{
    @Published var offsetPoint: CGPoint = .init(x: 0, y: 0)
    @Published var isDrag = false
    var width: CGFloat = 0.0
    var screenSize: CGSize = CGSize.zero

    init(isDrag: Bool = false, width: CGFloat, screenSize: CGSize ) {
        self.offsetPoint = .init(x: 0, y: 0)
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
