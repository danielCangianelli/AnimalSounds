import Foundation
import AVFoundation
import SoundAnalysis
import CoreML

@MainActor
final class SoundClassifierViewModel: ObservableObject {
    @Published var result: String = "Aguardando som..."

    private let audioEngine = AVAudioEngine()
    private var streamAnalyzer: SNAudioStreamAnalyzer!
    private var inputBus: AVAudioNodeBus = 0
    private let analysisQueue = DispatchQueue(label: "com.animalSound.analysisQueue")
    private var observer: SNResultsObserving!

    func startAudioClassification() {
        do {
            guard let modelURL = Bundle.main.url(forResource: "AnimalSounds", withExtension: "mlmodelc") else {
                fatalError("Modelo AnimalSounds.mlmodelc não encontrado no bundle.")
            }

            let model = try MLModel(contentsOf: modelURL)
            let request = try SNClassifySoundRequest(mlModel: model)

            // Configuração do fluxo de áudio
            let inputNode = audioEngine.inputNode
            let format = inputNode.outputFormat(forBus: inputBus)
            streamAnalyzer = SNAudioStreamAnalyzer(format: format)

            // Observador que tratará os resultados
            observer = ResultObserver { [weak self] classification in
                DispatchQueue.main.async {
                    self?.result = classification
                }
            }

            try streamAnalyzer.add(request, withObserver: observer)

            inputNode.installTap(onBus: inputBus, bufferSize: 8192, format: format) {
                [weak self] (buffer, time) in
                self?.analysisQueue.async {
                    self?.streamAnalyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
                }
            }

            try audioEngine.start()

        } catch {
            print("Erro ao iniciar a classificação: \(error.localizedDescription)")
        }
    }

    func stopAudioClassification() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: inputBus)
        result = "Classificação parada."
    }
}


class ResultObserver: NSObject, SNResultsObserving {
    let resultHandler: (String) -> Void

    init(resultHandler: @escaping (String) -> Void) {
        self.resultHandler = resultHandler
    }

    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let classification = result as? SNClassificationResult,
              let topResult = classification.classifications.first,
              topResult.confidence > 0.4 else { return }

        resultHandler("\(topResult.identifier) (\(String(format: "%.2f", topResult.confidence * 100))%)")
    }

    func request(_ request: SNRequest, didFailWithError error: Error) {
        print("Erro de classificação: \(error.localizedDescription)")
    }

    func requestDidComplete(_ request: SNRequest) {
        print("Classificação completa.")
    }
}
