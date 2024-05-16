import AudioKit
import AVFoundation

class Conductor {
    var engine = AudioEngine()
    var mixer = Mixer()
    
    init() {
        engine.output = mixer
    }
    
    func start() {
        do {
            try engine.start()
        } catch let err {
            Log(err)
        }
    }
    
    func stop() {
        engine.stop()
    }
    
}
