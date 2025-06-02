# 🐾 Animal Sound Classifier

## Projeto completo de classificação de sons de animais baseado em Machine Learning. Composto por:

📊 Processamento de dados e preparação de dataset (ESC-50);

🧠 Treinamento do modelo via Create ML e [TensorFlow];

📱 Aplicativo iOS desenvolvido em SwiftUI + MVVM, com uso de microfone e modelo embarcado;

🧪 Exportação e uso do modelo em Python para testes automatizados.

## 📁 Estrutura do Projeto

```plaintext
AnimalSoundClassifier/
│
├── data/                    # CSV original e áudios do ESC-50
├── training_data/           # Dados de treino organizados por classe
├── testing_data/            # Dados de teste organizados por classe
├── notebooks/               # Notebooks de EDA, pré-processamento e avaliação
├── model/                   # Modelo treinado (.h5) + encoder (.pkl)
├── ios-app/                 # App iOS SwiftUI usando CoreML
├── export/                  # Exportações (.h5, .pkl)
├── predict.py               # Script de predição em Python
├── export_model.py          # Script de exportação de modelo e encoder
├── esc50.csv                # CSV oficial com metadados
├── README.md
```

### 📆 Dataset

Utiliza o *ESC-50*: Dataset for Environmental Sound Classification, filtrando 5 classes:

`dog`, `cat`, `cow`, `rooster`, `sheep`

##  🛠 Fluxo de Processamento

### 1. Preparação dos Dados

Executado em Jupyter Notebook com pandas, scikit-learn, librosa, etc.

selected_classes = ['dog', 'cat', 'cow', 'rooster', 'sheep']
test_set_size = 0.20

Filtragem das classes de interesse

Divisão entre treino e teste com train_test_split

Organização em diretórios separados por classe

### 2. Treinamento do Modelo

🔹 Opção A: Create ML

Projeto Sound Classifier

Configuração:

Window Duration: 1.0s

Overlap: 0.5s

Exportado como .mlmodel e utilizado diretamente no app iOS

🔹 Opção B: TensorFlow (Python)

model = Sequential([
    Dense(256, activation='relu', input_shape=(40,)),
    Dropout(0.3),
    Dense(128, activation='relu'),
    Dropout(0.3),
    Dense(num_classes, activation='softmax')
])

Extração de features com librosa (MFCC)

Acurácia final: ~70%

Exportação:

model.save('export/animal_sounds_model.h5')
with open('export/label_encoder.pkl', 'wb') as f:
    pickle.dump(encoder, f)

### 3. Testes em Python

Uso de predict.py para testar o modelo com novos .wav:

python predict.py caminho/do/arquivo.wav

Pré-processamento com MFCC

Decodificação da classe com LabelEncoder

### 4. App iOS com SwiftUI

Desenvolvido em SwiftUI + MVVM

Usa o microfone do dispositivo e o modelo .mlmodel

Permissões configuradas no Info.plist (ou via Swift para projetos sem plist)

🔐 Permissões

NSMicrophoneUsageDescription = "Este app precisa acessar o microfone para identificar sons de animais."

🔍 Verificação de permissão

switch AVAudioSession.sharedInstance().recordPermission {
case .undetermined:
    AVAudioSession.sharedInstance().requestRecordPermission { granted in ... }
case .denied:
    // Informar o usuário
case .granted:
    // Continuar normalmente
}

📦 Requisitos

Python

pip install pandas librosa scikit-learn tensorflow matplotlib

iOS

Xcode 15+

Swift 6

Target: iOS 16+

🧠 Autor

- **DuckNCode** - *Desenvolvedor principal* - [@dCangianelli](https://github.com/danielCangianelli)
