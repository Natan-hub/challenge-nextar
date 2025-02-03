# CHALLANGE NEXTAR
Este repositório contém um projeto desenvolvido utilizando Flutter e Firebase. Neste arquivo README, você encontrará um guia passo a passo para abrir o projeto em seu ambiente local.

https://github.com/user-attachments/assets/6acc8165-0f0d-49cf-a1f3-3a12013a6bba

> Esse projeto consiste em uma representação de um app de cadastro de produtos, eu fui um pouco além e deixei parecido com uma loja virtual mas sempre mantendo o cadastro de produtos como parte principal.

### Melhorias que com mais tempo poderiam ser incluídas

- [] Suporte Offline Completo
  > Poderia usar o shared_preferences para cache, ou um banco de dados local para maior robustez usando o pacote hive.
- [] Internacionalização
  > Usando o pacote flutter_localizations para adicionar suporte a múltiplos idiomas, criano as pastas l10n com os idiomas específicos e criando o JSON para tradução.
- [] Melhoria do acesso a câmera e galeria
  > No projeto atualmente para adicionarmos fotos ao produto podemos tirar uma foto ou pegar uma imagem da galeria, podemos melhorar isso dando escolha ao usuário de que quando ele acessar essas funções além de só tirar uma foto ele poder gravar um vídeo da câmera ou selecionar um de sua galeira, se ficou curioso sobre isso eu fiz uma postagem no linkedin sobre de como podemos fazer essa alternancia entre foto e vídeo. https://www.linkedin.com/posts/natanloss_flutter-desenvolvimentodeapps-inovaaexaeto-activity-7178538533236711424-w7G9?utm_source=share&utm_medium=member_desktop
- [] Testes Automatizados
  > Exemplo: 
![image](https://github.com/user-attachments/assets/c42eccef-9a5a-4619-8299-26b150ee7658)

## 💻 Pré-requisitos

Antes de começar, verifique se você atendeu aos seguintes requisitos:

- Versão do Flutter usada `<3.22.0>`
- Versão do Dart usada `<3.4.0>`
- Você tem uma máquina `<Windows>`.

## 🚀 Instalando <nome_do_projeto>

Para instalar o projeto, siga estas etapas:

Windows:
- Baixe o projeto desse repositório ou o clone em seu git.
- Acesse a pasta do projeto que contém os arquivos `<.yaml>`, a pasta principal é `<challange_nextar>`.
- Rode o comando abaixo
```
Flutter pub get
```
- Após rodar ele irá baixar todas as dependências do projeto, com isso basta rodar no terminal o próximo comando
```
flutter run --debug	
```
ou 
```
flutter run --release
```
- Com o debug podemos ver os logs, e ter acesso a ferramentas de depuração.
- Com o release executamos a versão final do app com otimizações, sem logs e hot-reload.

## 🧠​ Sobre o projeto

- Para fazer login e acessar a home:
```
user@gmail.com
123456
```

### 📌 Dependências do Projeto

| **Dependência** | **Descrição** |
|--------------|--------------|
| `cupertino_icons` | Ícones do iOS para usar no Flutter. |
| `firebase_core` | Inicializa o Firebase no app. Obrigatório para usar outros serviços Firebase. |
| `firebase_auth` | Autenticação de usuários (e-mail, Google, Facebook, etc.). |
| `firebase_storage` | Armazena e gerencia arquivos (imagens, PDFs, vídeos) na nuvem. |
| `cloud_firestore` | Banco de dados NoSQL em tempo real do Firebase. |
| `hidden_drawer_menu` | Cria um menu lateral oculto no app. |
| `google_fonts` | Permite usar fontes personalizadas do Google no Flutter. |
| `modal_bottom_sheet` | Exibe modais personalizados no estilo iOS e Android. |
| `flutter_svg` | Suporte para imagens SVG no Flutter. |
| `awesome_top_snackbar` | Exibe mensagens de notificação no topo da tela. |
| `provider` | Gerenciamento de estado simples e eficiente para Flutter. |
| `alphabet_scroll_view` | Lista com rolagem por letras (útil para listas ordenadas alfabeticamente). |
| `faker` | Gera dados fictícios para testes (nomes, emails, etc.). |
| `carousel_slider` | Cria carrosséis de imagens ou widgets. |
| `flutter_native_splash` | Adiciona uma tela de splash personalizada ao iniciar o app. |
| `animated_splash_screen` | Exibe uma tela de splash animada na inicialização. |
| `flutter_staggered_grid_view` | Cria layouts de grade com tamanhos diferentes (como Pinterest). |
| `image_picker` | Permite selecionar imagens da galeria ou câmera do dispositivo. |
| `image_cropper` | Corta e edita imagens antes de enviá-las. |
| `uuid` | Gera identificadores únicos (UUID) para objetos, como IDs de produtos. |
| `babstrap_settings_screen` | Facilita a criação de telas de configurações no app. |
| `shimmer` | Efeito de carregamento animado (Skeleton Loader). |
| `cached_network_image` | Carrega e armazena em cache imagens da internet para melhor desempenho. |

## 🤝 Colaboradores

Agradecemos às seguintes pessoas que contribuíram para este projeto:

<table>
  <tr>
    <td align="center">
      <a href="#" title="defina o título do link">
        <img src="https://avatars3.githubusercontent.com/u/31936044" width="100px;" alt="Foto do Iuri Silva no GitHub"/><br>
        <sub>
          <b>Natan Peliciolli Loss</b>
        </sub>
      </a>
    </td>
  </tr>
</table>
