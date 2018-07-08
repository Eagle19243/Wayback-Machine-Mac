//
//  SafariExtensionHandler.swift
//  Wayback Machine
//
//  Created by eagle on 3/2/17.
//  Copyright © 2017 Internet Archive. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    let httpFailCodes = [404, 408, 410, 451, 500, 502, 503, 504, 509, 520, 521, 523, 524, 525, 526]
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        
        page.getPropertiesWithCompletionHandler { properties in
//            NSLog("The extension received a message (\(messageName)) from a script injected into (\(properties?.url)) with userInfo (\(userInfo))")
        }
        
        if (messageName == "_onBeforeNavigate") {
            handleBeforeNavigate()
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        // This method will be called when your toolbar item is clicked.
        
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }
    
    override func popoverWillShow(in window: SFSafariWindow) {
        
    }
    
    func handleBeforeNavigate() {
        SFSafariApplication.getActiveWindow(completionHandler: {(activeWindow) in
            activeWindow?.getActiveTab(completionHandler: {(activeTab) in
                activeTab?.getActivePage(completionHandler: {(activePage) in
                    activePage?.getPropertiesWithCompletionHandler({ (properties) in
                        self.getResponse(url: properties?.url?.absoluteString, completion: {(status) in
                            
                            if (status == nil) {
                                return
                            }
                            
                            if (self.httpFailCodes.index(of: status!) == nil) {
                                return
                            }
                            
                            SafariExtensionViewController.shared.wmAvailabilityCheck(url: (properties?.url?.absoluteString)!, timestamp: nil, completion: { (wayback_url, url) in
                                
                                print("wmAvailabilityCheck-")
                                
                                if (wayback_url == nil) {
                                    return
                                }
                                
                                print("wmAvailabilityCheck-" + wayback_url!);
                                
                                SFSafariApplication.getActiveWindow(completionHandler: {(activeWindow) in
                                    activeWindow?.getActiveTab(completionHandler: {(activeTab) in
                                        activeTab?.getActivePage(completionHandler: {(activePage) in
                                            activePage?.dispatchMessageToScript(withName: "showBanner", userInfo: ["url": wayback_url!])
                                        })
                                    })
                                })
                                
                            })
                            
                        })
                    })
                })
            })
        })
    }
    
    func getResponse(url: String?, completion: @escaping (Int?) -> Void) {
        if (url == nil) {return}
        
        var request = URLRequest(url: URL(string: url!)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let _ = data, error == nil else {
                print("error=\(error)")
                return
            }
            
            let httpStatus = response as? HTTPURLResponse
            
            completion(httpStatus?.statusCode)
        }
        
        task.resume()
    }
    
}
