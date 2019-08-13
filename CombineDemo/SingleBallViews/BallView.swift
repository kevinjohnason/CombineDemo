//
//  BallView.swift
//  CombineDemo
//
//  Created by Kevin Minority on 7/31/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct BallView: View {
    var forgroundColor: Color
    var backgroundColor: Color
    @Binding var text: String
    
    var body: some View {
        Text($text.value)
        .font(.system(size: 14))
        .bold()
        .foregroundColor(forgroundColor)
        .padding()
        .background(backgroundColor)
        .clipShape(Circle())            
        .shadow(radius: 1)
    }
}

#if DEBUG
struct BallView_Previews: PreviewProvider {
    static var previews: some View {
        BallView(forgroundColor: .white, backgroundColor: .red, text: .constant("B"))
    }
}
#endif
