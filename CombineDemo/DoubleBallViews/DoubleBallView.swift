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
    @Binding var ballViewModel1: BallViewModel
    @Binding var ballViewModel2: BallViewModel
            
    var body: some View {
        HStack(spacing: 0) {
            BallView(forgroundColor: forgroundColor, backgroundColor: backgroundColor, viewModel: ballViewModel1)
            BallView(forgroundColor: forgroundColor, backgroundColor: backgroundColor, viewModel: ballViewModel2)
        }
    }
}

#if DEBUG
struct DoubleBallView_Previews: PreviewProvider {
    static var previews: some View {
        DoubleBallView(forgroundColor: .black, backgroundColor: .red,
                       ballViewModel1: .constant(BallViewModel(value: "")),
                       ballViewModel2: .constant(BallViewModel(value: "")))
    }
}
#endif
