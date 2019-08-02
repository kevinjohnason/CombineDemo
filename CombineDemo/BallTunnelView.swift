//
//  BallTunnelView.swift
//  CombineDemo
//
//  Created by Kevin Minority on 7/31/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct BallTunnelView: View {
    
    @Binding var percent: CGFloat
    @Binding var text: String
    @State var animate: Bool  = false
    
    var color: Color = .green
    
    var animationSecond: Double = 2
    
    var ballRadius: CGFloat = 75
    
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
            BallView(forgroundColor: .white, backgroundColor: self.color, text: self.$text)
                .frame(width: self.ballRadius, height: self.ballRadius, alignment: .center)
            .animation(nil)
            .offset(x: self.offset(from: tunnelGeometry))
            .animation(self.offsetAnimation)
                    .padding()
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 232/255.0, green: 232/255.0, blue: 232/255.0))
        }
         
    }
    
}

#if DEBUG
struct BallTunnelView_Previews: PreviewProvider {
    static var previews: some View {
        let tunnelView = BallTunnelView(percent: .constant(0), text: .constant("A"))
        
        return tunnelView
    }
}
#endif
