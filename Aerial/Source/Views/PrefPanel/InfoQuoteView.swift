//
//  InfoClockView.swift
//  Aerial
//
//  Created by Guillaume Louel on 18/12/2019.
//  Copyright © 2019 Guillaume Louel. All rights reserved.
//

import Cocoa

class InfoQuoteView: NSView {
    @IBOutlet var urlField: NSTextField!
    
    func setStates() {
        urlField.stringValue = PrefsInfo.quote.url
    }
    
    @IBAction func urlFieldChange(_ sender: NSTextField) {
        PrefsInfo.quote.url = sender.stringValue
    }
}
