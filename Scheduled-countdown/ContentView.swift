//
//  ContentView.swift
//  Scheduled-countdown
//
//  Created by Administrator on 2021-03-02.
//  Copyright © 2021 Mathias Halén. All rights reserved.
//

import SwiftUI

final class Print: ObservableObject{
    let BundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"]
    var number = Int.random(in: 0..<100)
    @Published var debug_number = ""

    
    init() {
        self.debug_number = BundleVersion as! String
        print("----------> IOS")
    }
}


struct ContentView: View {
    @ObservedObject var myPrint = Print()

    var body: some View {
        VStack{
            Text("debug_number \(myPrint.debug_number)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
