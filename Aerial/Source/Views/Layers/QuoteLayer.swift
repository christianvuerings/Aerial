//
//  LocationLayer.swift
//  Aerial
//
//  Created by Guillaume Louel on 11/12/2019.
//  Copyright © 2019 Guillaume Louel. All rights reserved.
//

import Foundation
import AVKit

class QuoteLayer: AnimationTextLayer {
    var config: PrefsInfo.Quote?
    var timeObserver: Any?
    var wasSetup = false

    override init(layer: Any) {
        super.init(layer: layer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Our inits
    override init(withLayer: CALayer, isPreview: Bool, offsets: LayerOffsets, manager: LayerManager) {
        super.init(withLayer: withLayer, isPreview: isPreview, offsets: offsets, manager: manager)
        
        // We start with a full opacity
        self.opacity = 1
    }

    convenience init(withLayer: CALayer, isPreview: Bool, offsets: LayerOffsets, manager: LayerManager, config: PrefsInfo.Quote) {
        self.init(withLayer: withLayer, isPreview: isPreview, offsets: offsets, manager: manager)
        self.config = config

        // Set our layer's font & corner now
        (self.font, self.fontSize) = getFont(name: config.fontName,
                                             size: config.fontSize)
        self.corner = config.corner
    }

    // We need to clear our callbacks on the player
    override func clear(player: AVPlayer) {
        if timeObserver != nil {
            player.removeTimeObserver(timeObserver!)
            timeObserver = nil
        }
    }

    // Called at each new video
    override func setupForVideo(video: AerialVideo, player: AVPlayer) {
        if wasSetup {
            return
        }
        
        Quotely.fetch { result in
            self.update(string: "After fetch")
            switch result {
            case .success(let data):
                if let name = data.quotes.randomElement()?.body {
                    self.update(string: name)
                    
                    let fadeAnimation = self.createFadeInAnimation()
                    self.add(fadeAnimation, forKey: "textfade")
                }
            case .failure(let error):
                if error == .requestFailed {
                    self.update(string: "Quotes not found")
                } else {
                    self.update(string: error.localizedDescription)
                }
            }
        }
        
//        update(string: "This is a test - yeaaaaaah")
        

    }
}
