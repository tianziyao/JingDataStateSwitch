//
//  JingDataPhoneScreen.swift
//  JingDataPhoneScreen
//
//  Created by Tian on 2018/8/30.
//

import Foundation


public enum JingDataPhoneScreen {
    
    case unknown
    case inch3_5
    case inch4_0
    case inch4_7
    case inch5_5
    case inch5_8
    
    public var size: CGSize {
        switch self {
        case .inch3_5:
            return CGSize(width: 320.0, height: 480.0)
        case .inch4_0:
            return CGSize(width: 320.0, height: 568.0)
        case .inch4_7:
            return CGSize(width: 375.0, height: 667.0)
        case .inch5_5:
            return CGSize(width: 414.0, height: 736)
        case .inch5_8:
            return CGSize(width: 375, height: 812)
        case .unknown:
            return CGSize.zero
        }
    }
    
    public static var current: JingDataPhoneScreen {
        let currentScreenSize = UIScreen.main.bounds.size
        let screens: [JingDataPhoneScreen] = [.inch3_5, .inch4_0, .inch4_7, .inch5_5, .inch5_8]
        var currentScreen: JingDataPhoneScreen = .unknown
        screens.forEach { (screen) -> () in
            if currentScreenSize == screen.size {
                currentScreen = screen
                return
            }
        }
        return currentScreen
    }
}
