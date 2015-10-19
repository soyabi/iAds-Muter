//
//  AppDelegate.swift
//  iAds Muter
//
//  Created by Hoang Tran on 8/20/15.
//  Copyright (c) 2015 Hoang Tran. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2.0)
    let enableMenuItem = NSMenuItem(title: "Enable", action: Selector("registerForItunesNotifications"), keyEquivalent: "e")
    let disableMenuItem = NSMenuItem(title: "Disable", action: Selector("unregisterForItunesNotifications"), keyEquivalent: "d")
    let menu = NSMenu()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            
            menu.addItem(NSMenuItem.separatorItem())
            menu.addItem(NSMenuItem(title: "Quit", action: Selector("terminate:"), keyEquivalent: "q"))
            statusItem.menu = menu
            registerForItunesNotifications();
        }
    }
    
    func applicationWillTerminate (aNotification: NSNotification) {
    }
    
    func registerForItunesNotifications () {
        if let _ = menu.itemWithTitle("Enable") {
            menu.removeItem(enableMenuItem)
        }
        
        menu.insertItem(disableMenuItem, atIndex: 0)
        NSDistributedNotificationCenter.defaultCenter().addObserver(self, selector:Selector("receivedNotification:") , name: "com.apple.iTunes.playerInfo", object: nil)
    }
    
    func unregisterForItunesNotifications () {
        if let _ = menu.itemWithTitle("Disable") {
            menu.removeItem(disableMenuItem)
        }
        menu.insertItem(enableMenuItem, atIndex: 0)
        NSDistributedNotificationCenter.defaultCenter().removeObserver(self, name: "com.apple.iTunes.playerInfo", object: nil)
    }
    
    func receivedNotification(notification: NSNotification){
        if let userInfo = notification.userInfo {
            print(userInfo)
            
            if(userInfo["nomenR"]?.length > 0) {
                unmute()
            }
            else {
                if let genre = userInfo["Genre"] as? String {
                    if genre == "Podcast" {
                        unmute()
                    }
                    else {
                        mute()
                    }
                }
                else {
                    mute()
                }
            }
        }
        
    }
    
    func mute () {
        if let script = NSAppleScript(source: "set volume with output muted") {
            var errorDict : NSDictionary?
            script.executeAndReturnError(&errorDict)
            if let hasError = errorDict {
                print("Error muting: \(hasError)")
            }
        }
    }
    
    func unmute () {
        if let script = NSAppleScript(source: "set volume without output muted") {
            var errorDict : NSDictionary?
            script.executeAndReturnError(&errorDict)
            if let hasError = errorDict {
                print("Error unmuting: \(hasError)")
            }
        }
        
    }
    
}

