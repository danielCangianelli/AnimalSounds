import SwiftUI
struct ContentView: View {
    @StateObject private var viewModel = SoundClassifierViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.result)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .padding()

            HStack(spacing: 20) {
                Button("Iniciar") {
                    viewModel.startAudioClassification()
                }
                .padding()
                .foregroundColor(.white)
                .background(.green)
                .clipShape(Capsule())

                Button("Parar") {
                    viewModel.stopAudioClassification()
                }
                .padding()
                .foregroundColor(.white)
                .background(.red)
                .clipShape(Capsule())
            }
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
