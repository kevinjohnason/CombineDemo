//
//  SingleStreamView.swift
//  CombineDemo
//
//  Created by Kevin Minority on 7/31/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine

struct SingleStreamView: View {
    
    @ObservedObject var viewModel: StreamViewModel<String>
    
    var color: Color = .green
    
    var displayActionButtons: Bool = true
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Text(viewModel.description)
                .font(.system(.headline, design: .monospaced))
                .lineLimit(nil).padding()
            BallTunnelView(values: $viewModel.values, color: color, animationSecond: viewModel.animationSeconds)
            if displayActionButtons {
                HStack {
                    CombineDemoButton(text: "Subscribe", backgroundColor: .blue) {
                      self.viewModel.subscribe()
                    }
                    CombineDemoButton(text: "Cancel", backgroundColor: .red) {
                      self.viewModel.cancel()
                    }
                }.padding()
            }
            Spacer()
        }.navigationBarTitle(viewModel.title)
        .navigationBarItems(trailing: trailingBarItem)
    }
    
    var trailingBarItem: some View {
        guard let dynamicStreamViewModel = viewModel as? DynamicStreamViewModel else {
            return AnyView(EmptyView())
        }
        let navigationLink = NavigationLink(destination: UpdateStreamView(viewModel: UpdateStreamViewModel(streamModel: dynamicStreamViewModel.streamModel), updateCompleted: {
            dynamicStreamViewModel.reload()
        })) {
            Text("Edit")
        }        
        return AnyView(navigationLink)
    }
}

#if DEBUG
struct SingleStreamView_Previews: PreviewProvider {
    static var previews: some View {
        SingleStreamView(viewModel: StreamViewModel(title:"", publisher: CombineService.shared.commonPublisher))
        //.previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
    }
}
#endif
