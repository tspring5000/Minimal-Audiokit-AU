import SwiftUI
import AudioKit

// Most of this can be done directly on the view, aside from deinit
// But these manager classes become more useful with more complex code
// Do not use onAppear and onDisappear, it seems to cause problems on the AU
class OscManager {
    var conductor: Conductor
    var osc: PlaygroundOscillator
    
    init(conductor: Conductor) {
        self.conductor = conductor
        self.conductor.start()
        self.osc = PlaygroundOscillator(waveform: Table(.sawtooth), amplitude: 0.5)
        self.conductor.mixer.addInput(self.osc)
        self.osc.start()
    }
    
    func setFreq(freq: Double) {
        self.osc.frequency = Float(freq)
    }
    
    deinit {
        self.conductor.mixer.removeInput(self.osc)
        self.osc.stop()
        self.conductor.stop()
    }
}

struct OscView: View {
    var conductor: Conductor
    var osc: OscManager
    @State var freq = 440.0
    
    init(conductor: Conductor) {
        self.conductor = conductor
        self.osc = OscManager(conductor: self.conductor)
    }
    
    var body: some View {
        Slider(value: $freq, in: 100.0...1000.0)
            .padding()
            .onChange(of: freq, initial: true) {
                osc.setFreq(freq: freq)
            }
    }
}

struct OscPreview: View {
    var conductor = Conductor()
    
    var body: some View {
        OscView(conductor: conductor)
    }
}

#Preview {
    OscPreview()
}
