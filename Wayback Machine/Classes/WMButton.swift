//
//  WMButton.swift
//  Wayback Machine Mac
//
//  Created by eagle on 5/1/17.
//  Copyright © 2017 Internet Archive. All rights reserved.
//

import Foundation
import Cocoa

class WMButton:  NSButton{
    
    override func draw(_ dirtyRect: NSRect) {
        /** draw */
        super.draw(dirtyRect)
        
        self.layer?.cornerRadius = 3
        self.layer?.masksToBounds = true
    }
    
    func setBackgroundColor(color: CGColor) {
        self.bezelStyle = .texturedSquare
        self.isBordered = false
        self.wantsLayer = true
        self.layer?.backgroundColor = color
    }
    
    func setTitleColor(color: NSColor) {
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center
        self.attributedTitle = NSAttributedString(string: self.title, attributes: [ NSForegroundColorAttributeName : color, NSParagraphStyleAttributeName : pstyle, NSFontAttributeName: NSFont(name: "Arial", size: 14)! ])
    }
}
