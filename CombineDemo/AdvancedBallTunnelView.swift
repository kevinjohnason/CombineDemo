//
//  AdvancedBallTunnelView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/2/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct AdvancedBallTunnelView: View {
    @Binding var percent: CGFloat
    @Binding var text: String
    @State var animate: Bool  = false
    @Binding var historialTexts: [String]
    var color: Color = .green
    
    var animationSecond: Double = 2
    
    var ballRadius: CGFloat = 48
    
    var offsetAnimation: Animation? {
        if percent == 0 {
            return nil
        }
        return .easeInOut(duration: animationSecond)
    }
    
    func offset(from tunnelGeometry: GeometryProxy) -> CGFloat {
        return -ballRadius * 3 / 2 + (tunnelGeometry.size.width +  ballRadius * 2)  * percent
    }
    
    
    var body: some View {
        GeometryReader { tunnelGeometry in
                HStack(spacing: 0) {
                    BallView(forgroundColor: .white, backgroundColor: self.color, text: self.$text)
                        .frame(width: self.ballRadius, height: self.ballRadius, alignment: .center)
                        .offset(x: self.offset(from: tunnelGeometry))
                        .animation(self.offsetAnimation)
                    Spacer()
                    HStack(spacing: 0) {
                        ForEach(self.historialTexts.reversed(), id: \.self) { text in
                            BallView(forgroundColor: .white, backgroundColor: self.color, text: .constant(text))
                                .frame(width: self.ballRadius, height: self.ballRadius, alignment: .center)
                        }
                        
                    }.animation(nil)
                }.padding([.top, .bottom])
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 242/255.0, green: 242/255.0, blue: 242/255.0))            
        }
    }
}

#if DEBUG
struct AdvancedBallTunnelView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedBallTunnelView(percent: .constant(0), text: .constant("A"), historialTexts: .constant([]))
    }
}
#endif
