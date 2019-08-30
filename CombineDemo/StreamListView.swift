//
//  StreamListView.swift
//  CombineDemo
//
//  Created by kevin.cheng on 8/30/19.
//  Copyright © 2019 Kevin Cheng. All rights reserved.
//

import SwiftUI

struct StreamListView: View {
    
    @State var storedStreams = DataService.shared.storedStreams {
        didSet {
            DataService.shared.storedStreams = self.storedStreams
        }
    }
    
    @State var alertInDisplay: Bool = false
    
    var body: some View {
        ForEach(storedStreams) { stream in
            NavigationLink(destination: SingleStreamView(viewModel: DynamicStreamViewModel(streamId: stream.id))) {
                MenuRow(detailViewName: stream.name)
            }
        }.onDelete { (index) in
            guard let removingIndex = index.first else {
                return
            }
            if self.storedStreams[removingIndex].isDefault {
                self.alert(isPresented: self.$alertInDisplay) { () -> Alert in
                    Alert(title: Text("test alert"), message: Text("test message"), dismissButton: .cancel())
                }
                return
            }
            self.storedStreams.remove(at: removingIndex)
        }.onMove { (source, destination) in
            var storedStreams = self.storedStreams
            storedStreams.move(fromOffsets: source, toOffset: destination)
            self.storedStreams = storedStreams
        }
    }
}

struct StreamListView_Previews: PreviewProvider {
    static var previews: some View {
        StreamListView()
    }
}
