//
//  ViewController.swift
//  Wayback Machine Mac
//
//  Created by eagle on 3/2/17.
//  Copyright © 2017 Internet Archive. All rights reserved.
//

import Cocoa
import SafariServices

class ViewController: NSViewController {
    
    @IBOutlet weak var labelTitle: NSTextField!
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.wantsLayer = true
        
        labelTitle.stringValue += version
    }
    
    override func viewDidAppear() {
        self.view.window?.styleMask = [NSWindowStyleMask.closable, NSWindowStyleMask.titled, NSWindowStyleMask.miniaturizable]
        self.view.layer?.backgroundColor = CGColor(red:1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }
    
    @IBAction func onShowPreferences(_ sender: Any) {
        // Provide instructions to users on how to turn on the extension in Safari.
        SFSafariApplication.showPreferencesForExtension(withIdentifier: "archive.org.Wayback-Machine-Mac.Wayback-Machine") { (error) in
            if error != nil {
                print("Error launching the extension's preferences: %@", error!)
                return
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

