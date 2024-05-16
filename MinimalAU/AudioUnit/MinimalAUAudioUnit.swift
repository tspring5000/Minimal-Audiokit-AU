import AVFoundation
import AudioKit

// Shouldn't need to change anything in this file aside from the class name to match your own app name (even thats optional)
// Though you may need to when adding AU functionality (eg midi, parameters)

public class MinimalAUAudioUnit: AUAudioUnit {
    var engine: AVAudioEngine!
    var conductor: Conductor!
    
    public override init(componentDescription: AudioComponentDescription,
                         options: AudioComponentInstantiationOptions = []) throws {

        conductor = Conductor()
        engine = conductor.engine.avEngine
        do {
            try super.init(componentDescription: componentDescription, options: options)
            try setOutputBusArrays()
        } catch {
            Log("Could not init audio unit")
            throw error
        }
        
        setInternalRenderingBlock() // set internal rendering block to actually handle the audio buffers
    }

    private func setInternalRenderingBlock() {
        self._internalRenderBlock = { [weak self] (actionFlags, timestamp, frameCount, outputBusNumber,
            outputData, renderEvent, pullInputBlock) in
            guard let self = self else { return 1 }
            _ = self.engine.manualRenderingBlock(frameCount, outputData, nil)
            return noErr
        }
    }

    override public func allocateRenderResources() throws {
        do {
            try engine.enableManualRenderingMode(.offline, format: outputBus.format, maximumFrameCount: 4096)
            
            try super.allocateRenderResources()
        } catch {
            return
        }
    }

    override public func deallocateRenderResources() {
        engine.stop()
        super.deallocateRenderResources()
    }

    // Internal Render block stuff
    open var _internalRenderBlock: AUInternalRenderBlock!
    override open var internalRenderBlock: AUInternalRenderBlock {
        return self._internalRenderBlock
    }

    // Default OutputBusArray stuff you will need
    var outputBus: AUAudioUnitBus!
    open var _outputBusArray: AUAudioUnitBusArray!
    override open var outputBusses: AUAudioUnitBusArray {
        return self._outputBusArray
    }
    
    open func setOutputBusArrays() throws {
        let defaultAudioFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)
        outputBus = try AUAudioUnitBus(format: defaultAudioFormat!)
        self._outputBusArray = AUAudioUnitBusArray(audioUnit: self, busType: AUAudioUnitBusType.output, busses: [outputBus])
    }
}
