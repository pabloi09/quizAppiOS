//
//  PointsView.swift
//  Quiz con SwiftUI
//
//  Created by Pablo Martín Redondo on 07/12/2019.
//  Copyright © 2019 Pablo Martín Redondo. All rights reserved.
//

import SwiftUI

struct PointsView: View {
    @ObservedObject var memory: Memory
    var body: some View {
        VStack{
            Text("\(memory.count)")
            .padding(7)
        }
        .background(Color.accentColor)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.black, lineWidth: 2))
        
    }
}

struct PointsView_Previews: PreviewProvider {
    static var previews: some View {
        PointsView(memory: Memory())
    }
}
