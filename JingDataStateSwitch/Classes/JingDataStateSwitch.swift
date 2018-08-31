//
//  JIngDataStatuView.swift
//  JingDataStateView
//
//  Created by Tian on 2018/8/30.
//

import Foundation
import JingDataPodResourceLoader
import JingDataPhoneScreen

fileprivate var JingDataStateViewKey: UInt8 = 0
fileprivate var JingDataStateKey: UInt8 = 0
fileprivate var JingDataAboveViewKey: UInt8 = 0

public extension Notification.Name {
    public struct JingDataStateView {
        static var setStateFail = Notification.Name.init("org.jingdata.stateView.setState.fail")
        static var insertStateViewFail = Notification.Name.init("org.jingdata.stateView.insert.fail")
        static var removeStateViewFail = Notification.Name.init("org.jingdata.stateView.remove.fail")
    }
}

@objc public enum JingDataViewState: Int, RawRepresentable {
    case none
    case loading
    case success
    case fail
    case empty
    case noAuth
}

@objc public protocol JingDataStateViewProtocol {
    var state: JingDataViewState { set get }
    var from: String { set get }
}

public typealias JingDataStateView = UIView & JingDataStateViewProtocol

@objc public protocol JingDataStateSwitch {
    @objc optional func insert(_ stateView: JingDataStateView, _ aboveView: UIView?)
    @objc optional func remove(_ stateView: JingDataStateView, _ aboveView: UIView?)
}

public extension JingDataStateSwitch {
    
    private var stateView: JingDataStateView? {
        get {
            return objc_getAssociatedObject(self, &JingDataStateViewKey) as? JingDataStateView
        }
        set {
            objc_setAssociatedObject(self, &JingDataStateViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var aboveView: UIView? {
        get {
            return objc_getAssociatedObject(self, &JingDataAboveViewKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &JingDataAboveViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func setup(_ stateView: JingDataStateView, aboveView: UIView? = nil) {
        self.stateView = stateView
        self.aboveView = aboveView
    }
    
    public func defaultStateSwitchSetup(_ aboveView: UIView? = nil) {
        self.stateView = JingDataDefaultStateView()
        self.aboveView = aboveView
    }
    
    private func removeStateView() {
        guard let stateView: JingDataStateView = stateView else {
            NotificationCenter.default.post(name: Notification.Name.JingDataStateView.removeStateViewFail, object: nil)
            return
        }
        if let remove = remove {
            remove(stateView, aboveView)
        }
        else {
            stateView.removeFromSuperview()
        }
    }
}

public extension JingDataStateSwitch where Self: UIViewController {

    public var state: JingDataViewState? {
        get {
            return objc_getAssociatedObject(self, &JingDataStateKey) as? JingDataViewState
        }
        set {
            objc_setAssociatedObject(self, &JingDataStateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let state: JingDataViewState = state {
                stateView?.state = state
                switch state {
                case .success:
                    removeStateView()
                default:
                    insertStateView()
                }
            }
            else {
                NotificationCenter.default.post(name: Notification.Name.JingDataStateView.setStateFail, object: nil)
            }
        }
    }

    private func insertStateView() {
        guard let stateView: JingDataStateView = stateView else {
            NotificationCenter.default.post(name: Notification.Name.JingDataStateView.insertStateViewFail, object: nil)
            return
        }
        
        if let insert = insert {
            insert(stateView, aboveView)
        }
        else {
            stateView.removeFromSuperview()
            if let index = view.subviews.index(where: {$0 is UINavigationBar}) {
                view.insertSubview(stateView, belowSubview: view.subviews[index])
            }
            else {
                view.addSubview(stateView)
            }
            if let aboveView = aboveView {
                view.bringSubview(toFront: aboveView)
            }
            stateView.translatesAutoresizingMaskIntoConstraints = false
            stateView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
    }
}

public extension JingDataStateSwitch where Self: UIView {
    
    public var state: JingDataViewState? {
        get {
            return objc_getAssociatedObject(self, &JingDataStateKey) as? JingDataViewState
        }
        set {
            objc_setAssociatedObject(self, &JingDataStateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if let state: JingDataViewState = state {
                stateView?.state = state
                switch state {
                case .success:
                    removeStateView()
                default:
                    insertStateView()
                }
            }
            else {
                NotificationCenter.default.post(name: Notification.Name.JingDataStateView.setStateFail, object: nil)
            }
        }
    }
    
    private func insertStateView() {
        guard let stateView: JingDataStateView = stateView else {
            NotificationCenter.default.post(name: Notification.Name.JingDataStateView.insertStateViewFail, object: nil)
            return
        }
        if let insert = insert {
            insert(stateView, aboveView)
        }
        else {
            stateView.removeFromSuperview()
            if let index = self.subviews.index(where: {$0 is UINavigationBar}) {
                self.insertSubview(stateView, belowSubview: self.subviews[index])
            }
            else {
                self.addSubview(stateView)
            }
            if let aboveView = aboveView {
                self.bringSubview(toFront: aboveView)
            }
            stateView.translatesAutoresizingMaskIntoConstraints = false
            stateView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            stateView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            stateView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            stateView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        }
    }
}

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let r = CGFloat(((hex & 0xFF0000) >> 16)) / 255.0
        let g = CGFloat(((hex & 0xFF00) >> 8)) / 255.0
        let b = CGFloat(((hex & 0xFF))) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

let bundle = Bundle.library(with: JingDataDefaultStateView.self, name: "JingDataStateSwitch")

public class JingDataDefaultStateView: JingDataStateView {
    
    var indicatorCenterYOffset: CGFloat {
        switch JingDataPhoneScreen.current {
        case .inch5_8:
            return 44
        default:
            return 20
        }
    }
    
    var imageViewCenterYOffset: CGFloat = -72
    let progressAnimationKey = "StateView.progressAnimationKey"
    
    let indicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = bundle?.image("common_toast_loading")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(hex: 0x8C6CF5)
        imageView.frame.size = CGSize(width:25, height:25)
        return imageView
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.sizeToFit()
        view.isHidden = true
        return view
    }()
    
    let label: UILabel = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        view.textColor = UIColor(hex: 0x999999)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.sizeToFit()
        view.isHidden = true
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: 0xf6f6f6)
        addSubview(indicator)
        addSubview(imageView)
        addSubview(label)
    }
    
    private func rotateAnimtion() -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = 2.0 * .pi
        animation.duration = 1.0
        animation.repeatCount = Float(INT_MAX)
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    public var state: JingDataViewState = .none {
        didSet {
            switch state {
            case .loading:
                if indicator.layer.action(forKey: progressAnimationKey) == nil {
                    indicator.layer.add(rotateAnimtion(), forKey: progressAnimationKey)
                }
                imageView.isHidden = true
                label.isHidden = true
                indicator.isHidden = false
            case .success: break
            case .fail:
                label.text = "请求失败"
                imageView.image = bundle?.image("common_placeholder_error")
                indicator.isHidden = true
                imageView.isHidden = false
                label.isHidden = false
            case .empty:
                label.text = "暂无数据"
                imageView.image = bundle?.image("common_placeholder_nodata")
                indicator.isHidden = true
                imageView.isHidden = false
                label.isHidden = false
            case .noAuth:
                label.text = "暂无权限"
                imageView.image = bundle?.image("common_placeholder_noAuth")
                indicator.isHidden = true
                imageView.isHidden = false
                label.isHidden = false
            default: break
            }
            label.sizeToFit()
            imageView.sizeToFit()
        }
    }
    
    public var from: String = "" {
        didSet {
            print(from)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        indicator.center = CGPoint(x: bounds.midX,y: bounds.midY + indicatorCenterYOffset)
        imageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        imageView.frame.origin.y = imageView.frame.origin.y + imageViewCenterYOffset
        label.frame.size.width = frame.size.width - 40
        label.center = CGPoint(x: bounds.midX, y: bounds.midY)
        label.frame.origin.y = (imageView.frame.origin.y + imageView.frame.size.height) + 10
    }
}




