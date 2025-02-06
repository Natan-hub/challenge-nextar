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
- [] Mudança do gerenciamento de estado de um Provider para Cubit ou Bloc
  > 1. Exemplo:
  > 2.![image](https://github.com/user-attachments/assets/6619899e-e64b-46d4-84f4-c9adb70f9dbc)
  > 3. Aqui é uma classe que estende Cubit<List<ArtigosModel>>, ou seja, esse Cubit gerencia um estado que é uma lista busca artigos na API com base em um termo de pesquisa (buscarArtigo) e, ao receber os dados, atualiza o estado com emit(artigos), notificando a interface para exibir os novos artigos.
  > 4. emit([...]) → Atualiza o estado do Cubit com os novos detalhes do chamado.
  > 5. A partir disso nós conseguimos usar o Bloc:
  >  ![image](https://github.com/user-attachments/assets/5117655c-13b7-417a-ab05-43b1b5a4061c)
  > 6. Esse código usa BlocBuilder, um widget do flutter_bloc que reconstrói a interface sempre que o estado do Cubit mudar.
  > 7. O BlocBuilder reconstrói a interface automaticamente sempre que o estado do Cubit muda. Isso elimina a necessidade de setState() e evita reconstruções desnecessárias.
- [] Quesitos de acessibilidade
  > 1. Pensando em deixar o aplicativo acessível para todos nós podemos adicionar um AutoSizeText nos textos para que se o usuário precisasse aumentar a fonta das letras o layou se ajustaria automáticamente.
  > 2. Poderíamos se basear em alternancia de cores entre modo escuro e claro e com isso adicionar opção para daltonismo no app fazendo essa mudança de cores.

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

## 🚀 APK do projeto para baixar
<a href="https://github.com/Natan-hub/challenge-nextar/raw/main/app-release.apk" download>
  <img src="https://img.shields.io/badge/Baixar%20APK-Download-blue?style=for-the-badge">
</a>



## 🧠​ Sobre o projeto

- Para fazer login e acessar a home:
```
user@gmail.com
123456
```
### 📌 Curiosidades
> Todas as cores do projeto foram retiradas do site e do instagram da Nextar;

### 📌 Telas e funções

![Captura de tela 2025-02-03 024156](https://github.com/user-attachments/assets/18e08b2d-4c41-403f-9518-2d7a8a096a95)
> NAVEGAÇÂO
. Aqui nós temos um Hidden Drawer para navegar entre as telas principais.

![Captura de tela 2025-02-02 222927](https://github.com/user-attachments/assets/9b34429e-ba73-4bfa-99a5-771d3c643616)
> TELA LOGIN - Primeira tela que o usuário vai ver se não estiver logado nela nós temos:
1. A imgem da loja online
2. Campo para colocar o email
3. Campo para colocar a senha e no mesmo um iconButton para o usuário ter a opção de visualizar a senha ou não
4. Um TextButton "Esqueci minha senha" onde ao clicar vem uma tela hipotética de como seria para o usuário recuperar a senha(essa tela em si não faz nenhuma função)
5. O botão login para validar os campos e acessar a conta
6. E um texto meramente visual de criar conta.


![Captura de tela 2025-02-03 000446 - Copia](https://github.com/user-attachments/assets/e2645c68-4093-4733-9187-72446b7c4a2c)
> TELA HOME - Essa tela home é um PLUS do que foi pedido no escopo, se basendo na história da Nextar e de desenvolvimento de lojas virtuais essa tela é como se fosse o início de uma loja, uma boa apresentação para o usuário, nela nós temos:
1. Uma mensagem de bem vindo a sua loja para o usuário
2. Os campos listas e grades, esses campos servem para o usuário querer mostrar seus produtos principais nessa etapa da visualização nós temos as grades onde o usuário pode vincular um produto e com isso nós clicamos em cima de um item nessas seções e se tiver um produto vinculado nesse item iremos navegar para a tela de detalhes desse produto.
3. Logo mais abaixo nós temos um FloatingactionButton que ao clicar nele entramos no modo edição da home.

![Captura de tela 2025-02-03 000608](https://github.com/user-attachments/assets/f2a04835-392a-430a-977a-2edaac9c829f)
> TELA HOME MODO EDIÇÂO - Aqui é o modo de edição da tela home, nela, nós podemos: 
1. Remover a seção inteira clicando no ícone da lixeira
2. Editar o título da seção.
3. Adicionar uma imagem ao clicar no "+" das seções
4. Se executarmos o long press em cima da imagem é abeto um pop com as opões da vincular um produto naquele item, desvincular se já tem o produto ou excluir a imagem da lista
5. Logo abaixo temos o nosso FloatinActionButton ao entrar no modo edição ele fica com aqueles 3 pontinhos, e ao clicar em cima é exibido um menu com duas opções, uma sendo para salvar e a outra para descartar nossas alterações.

![Captura de tela 2025-02-03 011626](https://github.com/user-attachments/assets/a5aeda26-cf49-4dfe-a0d5-f1097cb4b97a)
> TELA DE PRODUTOS - Tela onde temos nossa listagem de produtos
1. Temos nosso card de produto com algumas informações
2. Logo abaixo temos o nosso FloatingActionButton
3. A tela também contém uma paginação para cerregar a cada 10 seções.

![Captura de tela 2025-02-03 011708](https://github.com/user-attachments/assets/65bc6745-fa52-42ad-b78d-35fcad6de1f6)
> TELA DE PRODUTOS FUNÇÕES- As funções que temos na nossa tela são: 
1. Como podemos ver ao segurarmos o card ele é selecionado com a opção de excluirmos o produto (excluir produto direto do card)
2. Ao clicar no nosso FloatingActionButton ele se expande com as opções de excluir um produto caso ele estiver selecionado, adicionar um produto clicando no + e para abrirmos o pop up dos filtros.

![Captura](https://github.com/user-attachments/assets/2f7ed0df-cb79-4aee-8712-bd21b4f30016)
> TELA DE DETALHES PRODUTOS:
1. Na AppBar nós temos o IconButton para editar um pedido. 
2. Nessa tela nós temos os detalhes do nosso produto, tendo um carrosel de imagens caso o produto tenha mais de uma imagem
3. E logo abaixo temos todas as informações de um produto.

![Captura de tela 2025-02-03 024007](https://github.com/user-attachments/assets/5af15961-2a8f-4a44-b544-83270585cde1)
> TELA DE EDIÇÃO PRODUTOS:
1. Na AppBar nós temos o IconButton para excluir o produto. 
2. Já nosso carrosel é mostrado as imagens com um Icon de lixeira ao lado que da a opçao de excluir a imagem e ao rolar o carrosel até o final é nos mostrado uma camera com um símbolo de "+" para clicarmos e adicionarmos uma foto. 
3. E logo abaixo temos todas as informações de um produto que pdemos editar.

![Captura de tela 2025-02-03 024046](https://github.com/user-attachments/assets/b6eff1b1-df6f-4a88-ba7c-560d861b79c0)
> TELA DE CLIENTES:
1. Essa tela foi um plus que adicionei para mostrar conhecimento sobre o pacote faker para testarmos dados e como o pedido é para fazer um cadastero de produtos como se fosse uma loja eu simulei os clientes que o usuário possa ter na loja dele.

![Captura de tela 2025-02-03 024128](https://github.com/user-attachments/assets/c2bf6ca1-6cef-4e82-bd34-b45975186c52)
> TELA MINHA CONTA:
1. Essa tela foi um plus que adicionei onde o usuário possa visualizar ou alterar seus dados, como nome, email e senha
2. A tela tem a opção também de sair da conta para voltarmos a tela de login.
3. OBS: Nessa tela a alteração de dados é ilustrativo ela não altera os dados realmente


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
      <a href="https://www.linkedin.com/in/natanloss/" title="defina o título do link">
        <img src="https://avatars3.githubusercontent.com/u/31936044" width="100px;" alt="Foto do Iuri Silva no GitHub"/><br>
        <sub>
          <b>Natan Peliciolli Loss</b>
        </sub>
      </a>
    </td>
  </tr>
</table>
