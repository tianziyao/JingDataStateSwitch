//
//  JingDataPodResourceLoader.swift
//  JingDataPodResourceLoader
//
//  Created by Tian on 2018/8/30.
//

import Foundation
import JingDataPhoneScreen

extension JingDataPhoneScreen {
    var icon: String {
        switch self {
        case .inch3_5, .inch4_0, .inch4_7:
            return "@2x"
        default:
            return "@3x"
        }
    }
}


public extension Bundle {
    
    public static func library(with als: AnyClass, name: String) -> Bundle? {
        guard let url = libraryUrl(with: als, name: name) else { return nil }
        return Bundle(url: url)
    }
    
    public static func libraryUrl(with als: AnyClass, name: String) -> URL? {
        return Bundle(for: als).url(forResource: name, withExtension: "bundle")
    }
    
    public func image(_ name: String, type: String = "png") -> UIImage? {
        let file = name + JingDataPhoneScreen.current.icon + ".\(type)"
        return UIImage(named: file, in: self, compatibleWith: nil)
    }
    
    public func image(ofFile name: String, type: String = "png") -> UIImage? {
        let file = name + JingDataPhoneScreen.current.icon
        guard let path = self.path(forResource: file, ofType: type) else { return nil }
        return UIImage(contentsOfFile: path)
    }
}
