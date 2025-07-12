import SwiftUI

struct StarsView: View{
    var body: some View {
        HStack(spacing: 3){
            ForEach(0..<5) { index in
                Image(systemName: "star.fill")
                
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundStyle(.gray)
            }
        }
    }
}

struct ReviewView: View{
    var stars: CGFloat = 0.0
    var body: some View {
        HStack(alignment: .center){
            GeometryReader { proxy in
                ZStack(alignment: .leading){
                StarsView()
                    Rectangle()
                        .fill(.yellow)
                        .frame(width: (proxy.size.width + 1.5) * (stars/5))
                }
                .frame(width: 20 * 5 + 3 * 4,height: 20)
                .mask(StarsView())

            }
            }
            .frame(width: 20 * 5 + 3 * 4,height: 20)
            Text("\(String(format: "%.1f", stars))")
                .font(.system(.subheadline, design: .monospaced))
    }
}

#Preview {
    ReviewView()
}
