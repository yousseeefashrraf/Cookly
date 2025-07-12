import SwiftUI


extension LinearGradient{
    init(topLeadingBottomTrailingOf colors: [Color]){
    self =  LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
