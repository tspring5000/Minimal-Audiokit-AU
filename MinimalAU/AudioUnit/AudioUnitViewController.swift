import Combine
import CoreAudioKit
import os
import SwiftUI

// Shouldn't need to change much in this file aside from changing the names of the AUAudioUnit.swift file and AUMainView.swift file
// Though you may need to when adding AU functionality (eg midi, parameters)

private let log = Logger(subsystem: "com.example.Minimal-Audiokit-AU.MinimalAU", category: "AudioUnitViewController")

public class AudioUnitViewController: AUViewController, AUAudioUnitFactory {
    var audioUnit: MinimalAUAudioUnit?
    var hostingController: UIHostingController<MinimalAUMainView>?
    
    public func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        audioUnit = try MinimalAUAudioUnit(componentDescription: componentDescription, options: [])
        
        guard let audioUnit = self.audioUnit else {
            log.error("Unable to create MinimalAUAudioUnit")
            return audioUnit!
        }
        
        defer {
            DispatchQueue.main.async {
                self.configureSwiftUIView(audioUnit: audioUnit)
            }
        }
        
        return audioUnit
    }
    
    private func configureSwiftUIView(audioUnit: MinimalAUAudioUnit) {
        if let host = hostingController {
            host.removeFromParent()
            host.view.removeFromSuperview()
        }

        let content = MinimalAUMainView(conductor: audioUnit.conductor)
        let host = UIHostingController(rootView: content)
        self.addChild(host)
        host.view.frame = self.view.bounds
        self.view.addSubview(host.view)
        hostingController = host
        
        // Make sure the SwiftUI view fills the full area provided by the view controller
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        host.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        host.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        host.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.view.bringSubviewToFront(host.view)
    }
    
}
