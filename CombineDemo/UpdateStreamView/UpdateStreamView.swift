//
//  UpdateStreamView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/27/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI
import Combine
struct UpdateStreamView: View {
    
    @State var values: [TimeSeriesValue<String>] = []        
    
    @ObservedObject var viewModel: UpdateStreamViewModel = UpdateStreamViewModel(streamOptions: (1...8).map { BallViewModel(value: String($0)) })
    
    let tunnelPadding: CGFloat = 5
    
    var body: some View {
        BallTunnelView(values: self.$values, color: .red, padding: 5)
            .overlayPreferenceValue(TunnelPreferenceKey.self) { preferences in
                GeometryReader { reader in
                    HStack {
                        ForEach(self.viewModel.streamOptions) { option in                            
                            BallView(forgroundColor: .white, backgroundColor: .red, draggable: true, viewModel: option) { location in
                                guard let boundsAnchor = preferences.bounds else {
                                    return
                                }
                                let tunnelBounds = reader[boundsAnchor]
                                let height = tunnelBounds.height
                                let lowerY = height * 1
                                let higherY = height * 2
                                if location.y <= -lowerY  && location.y >= -higherY  {
                                    self.values.append(TimeSeriesValue(value: option.value))
                                }
                            }
                        }
                    }.offset(x: 0, y: reader[preferences.bounds!].height * 2)
                }
        }
    }
}

struct UpdateStreamView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateStreamView()
    }
}
