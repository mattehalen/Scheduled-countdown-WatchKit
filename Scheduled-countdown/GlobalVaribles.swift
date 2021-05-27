//
//  GlobalVaribles.swift
//  Scheduled-countdown
//
//  Created by Mathias Halén on 2021-05-27.
//  Copyright © 2021 Mathias Halén. All rights reserved.
//

import Foundation
import SwiftUI

class GlobalVaribles: NSObject,ObservableObject {
    
    static let sharedInstance = GlobalVaribles()
    @Published var currentTime = ""
    @Published var title = ""
    @Published var time = ""
    @Published var countDownBool = true
    @Published var bgColor = "#000000"
    @Published var countDownTimeInMS = 0
    @Published var connected = false

}
