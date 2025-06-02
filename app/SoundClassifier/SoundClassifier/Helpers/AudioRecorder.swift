import Foundation
import AVFoundation

final class AudioRecorder: NSObject, ObservableObject {
    var audioEngine: AVAudioEngine?
    private let audioSession = AVAudioSession.sharedInstance()
    private let inputBus: AVAudioNodeBus = 0
    
    var audioBufferCallback: ((AVAudioPCMBuffer, AVAudioTime) -> Void)?

    func startRecording() throws {
        audioEngine = AVAudioEngine()
        guard let engine = audioEngine else { return }

        try audioSession.setCategory(.record, mode: .default)
        try audioSession.setActive(true)

        let inputNode = engine.inputNode
        let format = inputNode.inputFormat(forBus: inputBus)

        inputNode.installTap(onBus: inputBus, bufferSize: 1024, format: format) { buffer, time in
            self.audioBufferCallback?(buffer, time)
        }

        engine.prepare()
        try engine.start()
    }

    func stopRecording() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: inputBus)
        audioEngine = nil
    }
}
