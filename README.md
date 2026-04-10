# eBolsaEA.App

Aplicativo móvel Flutter para gerenciamento de bolsas de estudo da Educação Adventista.

## 📱 Sobre o Projeto

O **eBolsaEA.App** é um aplicativo móvel desenvolvido em Flutter que permite aos usuários acompanhar e gerenciar seus processos de bolsas de estudo da Educação Adventista. O aplicativo oferece funcionalidades para visualização do status do processo, envio e correção de documentos, visualização do resultado da bolsa e recebimento de notificações sobre o andamento.

## 🚀 Funcionalidades Principais

### 🔐 Autenticação
- Login com ID de usuário
- Recuperação de senha
- Gerenciamento de sessão com refresh token
- Armazenamento seguro de credenciais

### 📊 Acompanhamento do Processo
- Visualização do status atual do processo de bolsa
- Acompanhamento do andamento em tempo real
- Histórico de atualizações do processo

### 📄 Gestão de Documentos
- Captura de fotos de documentos
- Scanner de documentos integrado
- Upload e envio de documentos
- Correção e reenvio de documentos quando necessário
- Visualização de documentos enviados

### 📋 Resultado da Bolsa
- Visualização do resultado final da bolsa
- Informações sobre aprovação/reprovação
- Detalhes da bolsa concedida

### 🔔 Notificações
- Recebimento de notificações sobre o andamento do processo
- Alertas sobre documentos pendentes
- Notificações sobre correções necessárias
- Atualizações sobre o status da bolsa

## 🛠️ Tecnologias Utilizadas

### Framework e Linguagem
- **Flutter**: 3.5.0+
- **Dart**: SDK >=3.5.0 <4.0.0

### Arquitetura e Gerenciamento de Estado
- **Flutter Modular**: Injeção de dependência e roteamento
- **Flutter Triple**: Gerenciamento de estado (Store pattern)
- **Either Dart**: Tratamento de erros funcional

### Armazenamento e Persistência
- **Hive**: Armazenamento local
- **Flutter Secure Storage**: Armazenamento seguro de tokens
- **Path Provider**: Gerenciamento de arquivos

### Comunicação e APIs
- **Dio**: Cliente HTTP
- **JWT Decoder**: Decodificação de tokens JWT
- **Firebase**: Analytics, Messaging e Core

### Captura e Processamento de Documentos
- **Document Scanner Flutter**: Scanner de documentos
- **Camera**: Captura de fotos
- **Open Document**: Visualização de documentos
- **PDF**: Geração e manipulação de PDFs

### Notificações e Permissões
- **Flutter Local Notifications**: Notificações locais
- **Permission Handler**: Gerenciamento de permissões
- **Device Info Plus**: Informações do dispositivo

### Validação e Formatação
- **CPF CNPJ Validator**: Validação de documentos
- **Mask Text Input Formatter**: Formatação de campos
- **Intl**: Internacionalização

### UI/UX
- **Flutter Native Splash**: Tela de splash
- **Icons Launcher**: Ícones do aplicativo
- **Dotted Border**: Bordas pontilhadas
- **Expansion Widget**: Widgets expansíveis

## 🏗️ Arquitetura do Projeto

### Estrutura de Módulos

```
lib/
├── app/
│   ├── app_module.dart          # Módulo principal
│   ├── app_widget.dart          # Widget raiz
│   ├── core/                    # Funcionalidades core
│   │   ├── constants/           # Constantes
│   │   ├── endpoints/           # Configuração de APIs
│   │   ├── entities/            # Entidades de domínio
│   │   ├── exceptions/          # Exceções customizadas
│   │   ├── i18n/               # Internacionalização
│   │   ├── icons/              # Ícones customizados
│   │   ├── services/           # Serviços (HTTP, Storage)
│   │   ├── stores/             # Stores de estado
│   │   ├── themes/             # Temas
│   │   └── widgets/            # Widgets compartilhados
│   └── modules/                # Módulos da aplicação
│       ├── auth/               # Módulo de autenticação
│       ├── design_system/      # Sistema de design
│       ├── home/               # Módulo principal
│       ├── review_documents/   # Revisão de documentos
│       └── splash/             # Tela de splash
```

### Padrões Arquiteturais

- **Clean Architecture**: Separação clara entre camadas
- **Domain-Driven Design**: Foco no domínio de negócio
- **Repository Pattern**: Abstração de acesso a dados
- **Store Pattern**: Gerenciamento de estado
- **Dependency Injection**: Injeção de dependências com Modular

## 🔧 Configuração do Ambiente

### Pré-requisitos

- Flutter SDK 3.5.0 ou superior
- Dart SDK 3.5.0 ou superior
- Android Studio / VS Code
- Git

### Instalação

1. **Clone o repositório**
   ```bash
   git clone [URL_DO_REPOSITORIO]
   cd eBolsaEA.App
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Configure o ambiente de desenvolvimento**
   ```bash
   flutter doctor
   ```

### Configuração de Flavors

O projeto suporta dois ambientes:

#### Desenvolvimento
```bash
flutter run --flavor dev -t lib/main_dev.dart
```

#### Produção
```bash
flutter run --flavor prod -t lib/main_prod.dart
```

### Configuração do Firebase

1. **Android**: Configure o `google-services.json` nas pastas:
   - `android/app/src/dev/`
   - `android/app/src/prod/`

2. **iOS**: Configure o `GoogleService-Info.plist` nas pastas:
   - `ios/config/dev/`
   - `ios/config/prod/`

## 🚀 Como Executar

### Desenvolvimento
```bash
# Executar em modo desenvolvimento
flutter run --flavor dev -t lib/main_dev.dart

# Build para Android (dev)
flutter build apk --flavor dev -t lib/main_dev.dart

# Build para iOS (dev)
flutter build ios --flavor dev -t lib/main_dev.dart
```

### Produção
```bash
# Executar em modo produção
flutter run --flavor prod -t lib/main_prod.dart

# Build para Android (prod)
flutter build apk --flavor prod -t lib/main_prod.dart

# Build para iOS (prod)
flutter build ios --flavor prod -t lib/main_prod.dart
```

## 📱 Funcionalidades Detalhadas

### Autenticação
- Login com ID de usuário
- Validação de CPF/CNPJ
- Recuperação de senha
- Refresh token automático
- Armazenamento seguro de sessão

### Captura de Documentos
- Scanner de documentos integrado
- Captura de fotos com câmera
- Validação de qualidade de imagem
- Preview antes do envio
- Suporte a múltiplos formatos

### Acompanhamento do Processo
- Visualização do status atual do processo
- Acompanhamento do andamento em tempo real
- Histórico de atualizações do processo
- Status de documentos enviados

### Resultado da Bolsa
- Visualização do resultado final da bolsa
- Informações sobre aprovação/reprovação
- Detalhes da bolsa concedida

### Notificações
- Recebimento de notificações sobre o andamento do processo
- Alertas sobre documentos pendentes
- Notificações sobre correções necessárias
- Atualizações sobre o status da bolsa
- Notificações push via Firebase
- Notificações locais
- Configuração de canais (Android)
- Permissões automáticas

## 🧪 Testes

```bash
# Executar todos os testes
flutter test

# Executar testes específicos
flutter test test/jtw_decoder_test.dart
```

## 📦 Build e Deploy

### Android
```bash
# Build APK
flutter build apk --flavor prod -t lib/main_prod.dart

# Build App Bundle
flutter build appbundle --flavor prod -t lib/main_prod.dart
```

### iOS
```bash
# Build para iOS
flutter build ios --flavor prod -t lib/main_prod.dart
```

## 🔧 Configurações Específicas

### Android
- Configuração de keystore para assinatura
- Permissões de câmera e armazenamento
- Configuração de notificações
- Suporte a diferentes densidades de tela

### iOS
- Configuração de capabilities
- Permissões de câmera e fotos
- Configuração de notificações
- Suporte a diferentes tamanhos de tela

## 📚 Recursos Adicionais

### Documentação
- [Flutter Documentation](https://docs.flutter.dev/)
- [Flutter Modular](https://pub.dev/packages/flutter_modular)
- [Flutter Triple](https://pub.dev/packages/flutter_triple)

### APIs
- **Desenvolvimento**: `https://api-ebolsa-dev.educadventista.org`
- **Produção**: `https://api-ebolsa.educadventista.org`

## 🤝 Desenvolvimento de novas Features

1. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
2. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
3. Push para a branch (`git push origin feature/AmazingFeature`)
4. Abra um Pull Request

## 📄 Licença

Este projeto é privado e pertence à Educação Adventista.

## 📞 Suporte

Para suporte técnico ou dúvidas sobre o projeto, entre em contato com a equipe de desenvolvimento.

---

**Versão**: 1.0.10+14  
**Última atualização**: Julho 2025
