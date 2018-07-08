//
//  SafariExtensionViewController.swift
//  Wayback Machine
//
//  Created by eagle on 3/2/17.
//  Copyright © 2017 Internet Archive. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared = SafariExtensionViewController()
    
    @IBOutlet weak var btnSave: WMButton!
    @IBOutlet weak var btnRecent: WMButton!
    @IBOutlet weak var btnFirst: WMButton!
    @IBOutlet weak var btnFacebook: WMButton!
    @IBOutlet weak var btnTwitter: WMButton!
    @IBOutlet weak var imageLogo: NSImageView!
    
    let version                 = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    let Save_URL                = "https://web.archive.org/save/"
    let Availability_API_URL    = "https://archive.org/wayback/available"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSave.setBackgroundColor(color: CGColor(red: 0.29, green: 0.68, blue: 0.31, alpha: 1.0))
        btnSave.setTitleColor(color: NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        btnSave.image = self.resize(image: btnSave.image!, w: Int(btnSave.frame.width), h: Int(btnSave.frame.height))
        btnRecent.setBackgroundColor(color: CGColor(red: 0.29, green: 0.68, blue: 0.31, alpha: 1.0))
        btnRecent.setTitleColor(color: NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        btnRecent.image = self.resize(image: btnRecent.image!, w: Int(btnRecent.frame.width), h: Int(btnRecent.frame.height))
        btnFirst.setBackgroundColor(color: CGColor(red: 0.29, green: 0.68, blue: 0.31, alpha: 1.0))
        btnFirst.setTitleColor(color: NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        btnFirst.image = self.resize(image: btnFirst.image!, w: Int(btnFirst.frame.width), h: Int(btnFirst.frame.height))
        
        imageLogo.image = self.resize(image: imageLogo.image!, w: Int(imageLogo.frame.width), h: Int(imageLogo.frame.height))
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
        
    }
    
    //- MARK: Actions

    @IBAction func _onSavePageNow(_ sender: Any) {
        SFSafariApplication.getActiveWindow { (activeWindow) in
            activeWindow?.getActiveTab(completionHandler: { (activeTab) in
                activeTab?.getActivePage(completionHandler: { (activePage) in
                    activePage?.getPropertiesWithCompletionHandler({ (properties) in
                        if let url = properties?.url?.absoluteString {
                            SFSafariApplication.getActiveWindow { (activeWindow) in
                                activeWindow?.openTab(with: URL(string: (self.Save_URL + url))!, makeActiveIfPossible: true, completionHandler: {(tab) in
                                })
                            }
                        }
                    })
                })
            })
        }
    }
    
    @IBAction func _onRecentVersion(_ sender: Any) {
        
        SFSafariApplication.getActiveWindow { (activeWindow) in
            activeWindow?.getActiveTab(completionHandler: { (activeTab) in
                activeTab?.getActivePage(completionHandler: { (activePage) in
                    activePage?.getPropertiesWithCompletionHandler({ (properties) in
                        
                        if properties == nil {return}
                        
                        self.wmAvailabilityCheck(url: self.getOriginalURL(url: (properties?.url?.absoluteString)!), timestamp: nil, completion: {(wayback_url, url) in
                            
                            if (wayback_url == nil) {return}
                            
                            SFSafariApplication.getActiveWindow(completionHandler: {(activeWindow) in
                                activeWindow?.openTab(with: URL(string: wayback_url!)!, makeActiveIfPossible: true, completionHandler: { (activeTab) in
                                })
                            })
                        })
                    })
                })
            })
    }
        }
    
    @IBAction func _onFirstVersion(_ sender: Any) {
        SFSafariApplication.getActiveWindow { (activeWindow) in
            activeWindow?.getActiveTab(completionHandler: { (activeTab) in
                activeTab?.getActivePage(completionHandler: { (activePage) in
                    activePage?.getPropertiesWithCompletionHandler({ (properties) in
                        
                        if properties == nil {return}
                        
                        self.wmAvailabilityCheck(url: self.getOriginalURL(url: (properties?.url?.absoluteString)!), timestamp: "00000000000000", completion: {(wayback_url, url) in
                            
                            if (wayback_url == nil) {return}
                            
                            SFSafariApplication.getActiveWindow(completionHandler: {(activeWindow) in
                                activeWindow?.openTab(with: URL(string: wayback_url!)!, makeActiveIfPossible: true, completionHandler: { (activeTab) in
                                })
                            })
                        })
                    })
                })
            })
        }
    }
    
    @IBAction func _onFacebook(_ sender: Any) {
        SFSafariApplication.getActiveWindow { (activeWindow) in
            activeWindow?.getActiveTab(completionHandler: { (activeTab) in
                activeTab?.getActivePage(completionHandler: { (activePage) in
                    activePage?.getPropertiesWithCompletionHandler({ (properties) in
                        let activeURL  = properties?.url?.absoluteString
                        let title      = properties?.title
                        
                        if (activeURL == nil) {return}
                        SFSafariApplication.getActiveWindow(completionHandler: {(activeWindow) in
                            let sharingURL = "https://www.facebook.com/sharer/sharer.php?u=\(activeURL!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!))&title=\(title!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
                            activeWindow?.openTab(with: URL(string: sharingURL)!, makeActiveIfPossible: true, completionHandler: { (activeTab) in
                            })
                        })
                    })
                })
            })
        }
    }
    
    @IBAction func _onTwitter(_ sender: Any) {
        SFSafariApplication.getActiveWindow { (activeWindow) in
            activeWindow?.getActiveTab(completionHandler: { (activeTab) in
                activeTab?.getActivePage(completionHandler: { (activePage) in
                    activePage?.getPropertiesWithCompletionHandler({ (properties) in
                        let activeURL  = properties?.url?.absoluteString
                        
                        if (activeURL == nil) {return}
                        
                        SFSafariApplication.getActiveWindow(completionHandler: {(activeWindow) in
                            let sharingURL = "http://twitter.com/share?url=\(activeURL!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)" + "&via=internetarchive"
                            activeWindow?.openTab(with: URL(string: sharingURL)!, makeActiveIfPossible: true, completionHandler: { (activeTab) in
                            })
                        })
                    })
                })
            })
        }
    }
    
    @IBAction func _onGooglePlus(_ sender: Any) {
        SFSafariApplication.getActiveWindow { (activeWindow) in
            activeWindow?.getActiveTab(completionHandler: { (activeTab) in
                activeTab?.getActivePage(completionHandler: { (activePage) in
                    activePage?.getPropertiesWithCompletionHandler({ (properties) in
                        let activeURL  = properties?.url?.absoluteString
                        
                        if (activeURL == nil) {return}
                        
                        SFSafariApplication.getActiveWindow(completionHandler: {(activeWindow) in
                            let sharingURL = "https://plus.google.com/share?url=\(activeURL!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
                            activeWindow?.openTab(with: URL(string: sharingURL)!, makeActiveIfPossible: true, completionHandler: { (activeTab) in
                            })
                        })
                    })
                })
            })
        }
    }
    
    public func wmAvailabilityCheck(url: String, timestamp: String?, completion: @escaping (String?, String) -> Void) {
        
        var postString = "url=" + url
        
        if (timestamp != nil) {
            postString += "&&timestamp=" + timestamp!
        }
        
        var request = URLRequest(url: URL(string: Availability_API_URL)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.setValue("2", forHTTPHeaderField: "Wayback-Api-Version")
        request.setValue("Wayback_Machine_Safari_XC/\(version)", forHTTPHeaderField: "User-Agent")
        request.setValue("Wayback_Machine_Safari_XC/\(version)", forHTTPHeaderField: "Wayback-Extension-Version")
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]{
                    
                    completion(self.getWaybackUrlFromResponse(response: json), url)
                    
                } else {
                    completion(nil, url)
                }
                
            } catch _ {
                completion(nil, url)
            }
            
        }
        
        task.resume()
    }
    
    func getWaybackUrlFromResponse(response: [String: Any]) -> String? {
        let results = response["results"] as Any
        let results_first = ((response["results"] as? [Any])?[0])
        let archived_snapshots = (results_first as? [String: Any])?["archived_snapshots"]
        let closest = (archived_snapshots as? [String: Any])?["closest"]
        let available = (closest as? [String: Any])? ["available"] as? Bool
        let status = (closest as? [String: Any])? ["status"] as? String
        let url = (closest as? [String: Any])? ["url"] as? String
        
        if (results != nil &&
            results_first != nil &&
            archived_snapshots != nil &&
            closest != nil &&
            available != nil &&
            available == true &&
            status == "200" &&
            isValidSnapshotUrl(url: url)
            ) {
            return url!
        } else {
            return nil
        }
        
    }
    
    func isValidSnapshotUrl(url: String?) -> Bool {
        if (url == nil) {
            return false
        }
        
        if (url!.range(of: "http://") != nil || (url!.range(of: "https://") != nil)) {
                return true
        } else {
                return false
        }
    }
    
    func getOriginalURL(url: String) -> String {
        var originalURL:String? = nil
        let tempArray = url.components(separatedBy: "http")
        if (tempArray.count > 2) {
            originalURL = "http" + tempArray[2]
        } else {
            originalURL = url
        }
        
        return originalURL!
    }
    
    func resize(image: NSImage, w: Int, h: Int) -> NSImage {
        let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
        let newImage = NSImage(size: destSize)
        newImage.lockFocus()
        image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.copy, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = destSize
        return NSImage(data: newImage.tiffRepresentation!)!
    }

}
