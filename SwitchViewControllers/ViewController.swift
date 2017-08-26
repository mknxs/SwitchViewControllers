//
//  ViewController.swift
//  SwitchViewControllers
//
//  Created by mkns on 2017/08/26.
//  Copyright © 2017年 smakino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Tab: Int {
        case top = 0
        case business = 1
        case world = 2
        case tech = 3
        case sports = 4
        
        static let defaultTab = Tab.top
        static let firstTab = Tab.top
        static let lastTab = Tab.sports
        
        func isLeftTab(target: Tab) -> Bool {
            return self.rawValue < target.rawValue
        }
        
        func isRightTab(target: Tab) -> Bool {
            return !self.isLeftTab(target: target)
        }
        
        func distance(target: Tab) -> Int {
            return abs(self.rawValue - target.rawValue)
        }
        
        var isFirstTab: Bool {
            return self == .top
        }
        
        var isLastTab: Bool {
            return self == .sports
        }
        
        var leftTab: Tab? {
            return self.isFirstTab ? nil : Tab(rawValue: self.rawValue - 1)
        }
        
        var rightTab: Tab? {
            return self.isLastTab ? nil : Tab(rawValue: self.rawValue + 1)
        }
    }
    
    struct Constants {
        struct Tab {
            static let CornerRadius: CGFloat = 4.0
        }
    }

    @IBOutlet weak var topTabButton: UIButton!
    @IBOutlet weak var businessTabButton: UIButton!
    @IBOutlet weak var worldTabButton: UIButton!
    @IBOutlet weak var techTabButton: UIButton!
    @IBOutlet weak var suportsTabButton: UIButton!
    @IBOutlet weak var tabsHolder: UIScrollView!
    
    var viewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
 
        [self.topTabButton,
         self.businessTabButton,
         self.worldTabButton,
         self.techTabButton,
         self.suportsTabButton].forEach { (b) in
            b?.layer.masksToBounds = true
            b?.layer.cornerRadius = Constants.Tab.CornerRadius
        }
        
        self.setupDetailTabs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let holder = self.tabsHolder {
            // holder.superview?.layoutIfNeeded()
            let h = holder.bounds.size.height
            holder.contentSize = CGSize(width: self.view.bounds.size.width * CGFloat(self.viewControllers.count),
                                        height: h)
        }

    }
    
    func setupDetailTabs() {
        let top = TopViewController(nibName: nil, bundle: nil)
        let business = BusinessViewController(nibName: nil, bundle: nil)
        let world = WorldViewController(nibName: nil, bundle: nil)
        let tech = TechViewController(nibName: nil, bundle: nil)
        let sports = SportsViewController(nibName: nil, bundle: nil)
        self.viewControllers = [top, business, world, tech, sports]
        
        guard self.viewControllers.count == Tab.lastTab.rawValue + 1 else {
            print("Tab count is incorrect.")
            return
        }
        
        let current = Tab.defaultTab
        self.addContent(forTab: current.leftTab)
        self.addContent(forTab: current)
        self.addContent(forTab: current.rightTab)
    }
    
    func addContent(forTab tab: Tab?) {
        if let t = tab, let c = self.viewController(forTab: t) {
            if let v = c.view {
                let s = self.tabsHolder.frame.size
                let x = self.view.frame.size.width * CGFloat(t.rawValue)
                v.frame = CGRect(x: x, y: 0, width: s.width, height: s.height)
                v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.addChildViewController(c)
                self.tabsHolder.addSubview(v)
                c.didMove(toParentViewController: self)
            }
        }
    }
    
    func removeContent(forTab tab: Tab?) {
        if let c = self.viewController(forTab: tab) {
            c.willMove(toParentViewController: nil)
            c.view.removeFromSuperview()
            c.removeFromParentViewController()
        }
    }
    
    func viewController(forTab tab: Tab?) -> UIViewController? {
        if let t = tab {
            return self.viewControllers[t.rawValue]
        }
        return nil
    }

}
