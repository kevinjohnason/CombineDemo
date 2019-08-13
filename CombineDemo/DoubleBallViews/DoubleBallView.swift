//
//  DoubleBallView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/7/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine
struct DoubleBallView: View {
    var forgroundColor: Color
    var backgroundColor: Color
    @Binding var text1: String
    @Binding var text2: String
        
    
    var body: some View {
        HStack(spacing: 0) {
            BallView(forgroundColor: forgroundColor, backgroundColor: backgroundColor, text: $text1)
            BallView(forgroundColor: forgroundColor, backgroundColor: backgroundColor, text: $text2)
        }
    }
}

#if DEBUG
struct DoubleBallView_Previews: PreviewProvider {
    static var previews: some View {
        DoubleBallView(forgroundColor: .black, backgroundColor: .red,
                       text1: .constant(""), text2: .constant(""))
    }
}
#endif
