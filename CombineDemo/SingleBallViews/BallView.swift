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
    var draggable: Bool = false
    @ObservedObject var viewModel: BallViewModel
    var draggingEnded: ((CGPoint) -> Void)?
    
    var body: some View {
        GeometryReader { reader in
            Text(self.viewModel.value)
                .font(.system(size: 14))
                .bold()
                .foregroundColor(self.forgroundColor)
                .padding()
                .background(self.backgroundColor)
                .clipShape(Circle())
                .shadow(radius: 1)
                .offset(self.viewModel.offset)
                .gesture(DragGesture(coordinateSpace: .local).onChanged({ (gestureValue) in
                    guard self.draggable else { return }
                    let width = reader.size.width                    
                    self.viewModel.offset = CGSize(width: gestureValue.location.x - width / 2, height: gestureValue.location.y - width / 2 )
                }).onEnded({ (gestureValue) in
                    guard self.draggable else { return }
                    self.viewModel.offset = CGSize.zero
                    self.draggingEnded?(gestureValue.location)
                }))
        }
    }
}

#if DEBUG
struct BallView_Previews: PreviewProvider {
    static var previews: some View {
        BallView(forgroundColor: .white, backgroundColor: .red,
                 viewModel: BallViewModel(value: ""))
    }
}
#endif
