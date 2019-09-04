//
//  DoubleBallTunnelView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/7/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct DoubleBallTunnelView: View {
    @Binding var values: [TimeSeriesValue<(String, String)>]
    var color: Color = .green
    
    var animationSecond: Double = 2
    
    var ballRadius: CGFloat = 48
    
    var body: some View {
        GeometryReader { tunnelGeometry in
            HStack(spacing: 0) {
                Spacer()
                ForEach(self.values.reversed()) { value in
                    DoubleBallView(forgroundColor: .white, backgroundColor: self.color, ballViewModel1: .constant(BallViewModel(value: value.value.0)), ballViewModel2: .constant(BallViewModel(value: value.value.1)))
                        .frame(width: self.ballRadius * 2, height: self.ballRadius, alignment: .center)
                        .transition(.asymmetric(insertion: .offset(x: -tunnelGeometry.size.width, y: 0), removal: .offset(x: tunnelGeometry.size.width, y: 0)))
                }
            }
            .frame(minWidth: max(tunnelGeometry.size.width, self.ballRadius * 2 * CGFloat(self.values.count)), minHeight: self.ballRadius, alignment: .trailing)
            .padding([.top, .bottom], 5)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
            .background(Color(red: 242/255.0, green: 242/255.0, blue: 242/255.0))
            .animation(.easeInOut(duration: self.animationSecond))
        }
    }
}

#if DEBUG
struct DoubleBallTunnelView_Previews: PreviewProvider {
    static var previews: some View {
        DoubleBallTunnelView(values: .constant([]))
    }
}
#endif
