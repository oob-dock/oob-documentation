# Documentação Plataforma OPUS Open Finance

## Caracterização do produto

A Plataforma OPUS Open Finance oferece todos os recursos necessários para integrar
Instituições Financeiras ao ecossistema do Open Finance Brasil.

Como uma solução completa para atender a todos os requisitos das normas regulatórias
do Open Finance Brasil, a plataforma implementa as funcionalidades necessárias
para atuação das instituições financeiras em todos os perfis possíveis:

- Detentor de conta
- Transmissor de dados
- Receptora de Dados
- Iniciador de Transações de Pagamento (ITP)

Esquematicamente, a Plataforma OPUS Open Finance funciona como um proxy,
integrando-se aos sistemas de retaguarda da instituição financeira
e atendendo às requisições recebidas de outros participantes do ecossistema para
criação de consentimentos, realização de pagamentos, transmissão de dados, etc.,
conforme ilustra a figura a seguir:

![Visão geral OPUS Open Finance](./imagens/visao-geral.png)

Dentre as funcionalidades oferecidas pela Plataforma OPUS Open Finance destacamos:

1. Gestão de consentimentos obtidos e fornecidos;
1. Gestão multimarcas que permite a configuração do produto para atender a
diferentes marcas em uma mesma instalação do produto;
1. Cadastro de indisponibilidades e registro de falhas junto ao
diretório de participantes do Open Finance Brasil, conforme normas regulatórias;
1. Servidor de autorização que implementa perfil de segurança
FAPI-BR (Financial-grade API) exigido pelas normas regulatórias,
incluindo suporte a DCR (Dynamic Client Registration)
e DCM (Dynamic Client Management), devidamente certificado pela OpenID Foundation;
1. Plataforma de Coleta de Métricas, que envia informações referentes às operações
para o grupo de governança do Open Finance Brasil segundo as especificações regulatórias;
1. Gestão de logs utilizando um modelo de arquivos de log distribuídos baseado no
Elastic, mas que pode ser substituído por qualquer ferramenta de logs
já utilizada pela instituição financeira;
1. Integração com os sistemas de retaguarda da instituição financeira através de
conectores que isolam a complexidade da plataforma e garantem a padronização do produto;
1. Componentes de apoio para acelerar a validação e implantação do produto,
tais comoPortal de Geração de Consentimentos White-label,
Tela de Handoff White-label, código fonte das telas de consentimento para
integração ao aplicativo móvel da instituição financeira, simulador do ecossistema
para validação da instalação, e testador para validação dos conectores.

Para a realização de operações de Iniciação de Pagamento via Open Finance ou pedidos
de recepção de dados, a Plataforma OPUS Open Finance oferece módulos que implementam
os protocolos de segurança e autenticação. Tais módulos são acessíveis através de
interfaces REST, simplificando bastante a construção de aplicações.

Para fins de auditoria todas as transações são devidamente registradas em arquivos
de log. Todos os dados em repouso da solução (seja em logs ou bases de dados) são
encriptados para garantir sigilo em caso de acesso não autorizado.

## Módulos da Solução

![Módulos da Solução OPUS Open Finance](./imagens/modulos.png)

### Módulo Detentor de Conta

Responsável pelo tratamento de pedidos pagamentos enviados por iniciadores de pagamentos.
Integra-se ao sistema de retaguarda responsável pela efetivação de pagamentos
(tipicamente Pix) através de um conector que isola a complexidade do ambiente
e garante padronização da plataforma entre diferentes ambientes de execução.

O tratamento de pedidos de iniciação de pagamento envolve a criação de um consentimento
após a autenticação e confirmação pelo cliente final, a validação de um consentimento
enviado pelo iniciador e o tratamento do pagamento até sua efetivação completa
(sinalizada pela chamada de um webhook).

Todos os detalhes da transação são salvos, de forma encriptada, na base de dados
e registrados em log, além de serem enviados ao Grupo de Governança do
Open Finance Brasil através da Plataforma de Coleta de Métricas, conforme a regulação.

### Módulo Transmissor de Dados

Responsável pelo tratamento de pedidos de compartilhamento de dados cadastrais e
transacionais de clientes da instituição.
Também integra-se aos sistemas de retaguarda através de conectores,
garantindo isolamento funcional e padronização da plataforma.

O tratamento de pedidos de compartilhamento de dados também envolve a criação de
consentimentos após autenticação e confirmação pelo cliente final,
porém sua validade é longa, sendo limitada a até 12 meses.
Durante sua vida útil, o consentimento pode ser utilizado para obtenção de dados,
de acordo com as permissões incluídas em seu momento de criação e
autorizadas pelo cliente final.

Para cada requisição recebida, o Módulo Transmissor de Dados efetua a validação
da instituição requisitante (incluindo assinaturas criptográficas),
da validade do consentimento, e verifica se as permissões incluem os dados requisitados.
Caso qualquer uma dessas validações tenha resultado negativo,
o módulo retorna automaticamente a mensagem de erro apropriada.
Desta forma, os conectores (e, por consequência, os sistemas de retaguarda)
são acionados única e exclusivamente em casos em que de fato o requisitante tem
autorização para acessar dados cadastrais e transacionais.

O Módulo também faz o envio de reportes obrigatórios para a
Plataforma de Coleta de Métricas.

![Diagrama de sequência ITP e recepção de dados com e sem OPUS Open Finance](./imagens/diag-seq-itp.png)

### Módulo de Iniciação de Transações de Pagamento

Um Iniciador de Transação de Pagamento (ITP), ou apenas Iniciador de Pagamentos,
é uma aplicação cliente que consome serviços de uma Detentora de Conta.
A Módulo ITP da plataforma OPUS Open Finance atua como um *middleware* que implementa
um facilitador para efetuação de iniciação de pagamentos via Open Finance,
abstraindo os fluxos operacionais.

Permite que consentimentos de iniciação de pagamentos sejam criados em uma única
requisição à API REST fornecida, e uma vez aprovado, esse consentimento seja
utilizado para efetuação da transação através de uma segunda requisição.

Adicionalmente, o módulo também é capaz de efetuar DCR (Dynamic Client Registration)
e DCM (Dynamic Client Management) em todas as
instituições Detentoras de Conta listadas no Diretório de Participantes do
Open Finance Brasil,
além de efetuar o envio automático de reportes obrigatórios para a Plataforma
de Coleta de Métricas.

Com isso, o módulo permite o desenvolvimento de aplicações que se beneficiem da
iniciação de pagamentos via Open Finance, porém sem a necessidade de implementação
dos diversos protocolos de segurança e outras obrigatoriedades.

### Módulo de Recepção de Dados (OPUS DRx)

O Módulo de Recepção de Dados é um *middleware* para consumo dos serviços de
Transmissoras de Dados, permitindo a criação de consentimentos de
compartilhamento de dados cadastrais e transacionais, e sua subsequente utilização.

Análogo ao Módulo ITP, este módulo também permite que consentimentos sejam criados
em uma única requisição HTTP. Após sua aprovação, podem ser utilizados os
endpoints de *proxy* de obtenção de dados,
que adicionam assinaturas criptográficas e outros requisitos de segurança,
e retornam os dados devolvidos pela instituição receptora.

Assim, ele permite a consulta atômica de dados cadastrais e transacionais de
clientes de instituições participantes do Open Finance Brasil.
Esses dados incluem, entre outras informações:
dados pessoais como nome, data de nascimento, endereço, e dados transacionais de
contas, cartão de crédito, e operações de crédito (empréstimos, financiamentos, etc.).

O módulo também efetua DCR e DCM e o envio automático de reportes obrigatórios
para a Plataforma de Coleta de Métricas.

### Módulo OPUS Open Data Receiver

Como extensão das funcionalidades do Módulo de Recepção de Dados,
a plataforma oferece também o módulo OPUS Open Data Receiver,
capaz de agregar dados de clientes e mantê-los atualizados durante toda a
vigência dos consentimentos obtidos.

![Diagrama esquemático do OPUS Open Data Receiver](./imagens/opus-open-data-receiver.png)

Ele utiliza um *Scheduler*
e as capacidades do Módulo de Recepção de Dados (OPUS DRx)
para garantir que os dados sejam atualizados periodicamente,
respeitando os limites operacionais definidos pela regulação do Open Finance Brasil.

O módulo oferece uma API que consolida e unifica todos os dados referentes a
uma mesma pessoa.
Por exemplo,
caso um cliente final tenha contas em diferentes instituições, é possível criar diversos
consentimentos para obter os dados de todas elas.
Esses dados são consolidados e, através da Customer Data API,
é oferecida uma visão unificada, que retorna um extrato centralizado de todas
as transações do usuário nas diferentes insituições financeiras.

O sistema também alimenta uma fila de eventos,
que são disparados automaticamente quando ocorrem eventos técnicos,
como por exemplo quando um consentimento expira
ou é revogado pelo usuário,
e também permite a configuração de regras de negócio, como
detectar quando um usuário cria um novo contrato de empréstimo em outra instituição.
Dessa forma, é possível disparar ações para incentivar o usuário a renovar consentimentos
expirados (ex.: através do envio de notificações),
integrar com sistemas internos de CRM, etc.

Assim, o Módulo suporta a criação de outras aplicações que utilizem dados financeiros
dos usuários, sem a necessidade de se preocupar com atualização periódica
e consolidação de informações.

## Arquitetura da Solução

A arquitetura da solução é baseada em microsserviços,
para suportar escalabilidade horizontal automática,
e projetada para ser disponibilizada em contêineres (Docker)
rodando em ambiente de execução clusterizado Kubernetes.
A solução roda atualmente em produção tanto em ambientes Kubernetes gerenciados
(Google GKE, AWS AKS e Azure EKS) como clusters gerenciados manualmente.

![Arquitetura OPUS Open Finance](./imagens/arquitetura.png)

A plataforma foi concebida para rodar em uma estrutura de rede protegida por um
firewall e exige um API Gateway para sua correta configuração.
Caso a instituição financeira não possua um API Gateway corporativo (ou não queira
disponibilizá-lo para o ambiente Open Finance por questões de custo ou de governança)
o pacote de instalação possui uma opção pré-configurada para utilizar um
API Gateway Kong Community Edition sem custo adicional, garantindo que a solução
possa ser executada de maneira autônoma e sem dependências externas.

Todos os módulos do sistema suportam configuração de autoscaling, permitindo ao Kubernetes
criar (ou remover) instâncias baseando-se no uso de CPU e memória, por exemplo.

A distribuição dos módulos é realizada através de Helm charts, permitindo a definição,
instalação e upgrade da aplicação no Kubernetes, além da seleção de recursos
para execução no cluster.

A plataforma também faz uso de componentes de infraestrutura open source, como
Dapr, Grafana e Prometheus. Nesse caso, são disponibilizados scripts Terraform
para instalação e configuração.

Para a gestão de logs distribuídos a solução inclui o Elastic, mas pode ser configurado
outro produto (e incorporado ao pacote de distribuição da solução) caso exista um
padrão na instituição financeira.

## Componentes da solução

### Gestão de consentimentos

Responsável pelo ciclo de vida (criação, revogação e controle de expiração) dos consentimentos
criados na interação com Iniciadores de Pagamentos e Receptores de Dados.
Também controla os consentimentos obtidos pela instituição financeira.

Implementa uma API independente que permite, se desejável, a criação de aplicações
internas da instituição para consulta. Através dessa API atende aos pedidos de consultas
dos aplicativos Mobile e Web da instituição financeira para exibição dos consentimentos
válidos e revogados. Essa API também permite que a instituição implemente em seus
canais de atendimento a revogação de consentimentos – que é uma exigência das
normas regulatórias do Open Finance Brasil.

### Servidor de autorização

Implementa os perfis obrigatórios dos protocolos de segurança exigidos pelas
especificações do Open Finance Brasil, parte do FAPI-BR (Financial-grade API).

É o componente responsável pela execução dos protocolos de
DCR (Dynamic Client Registration) e DCM (Dynamic Client Management),
necessários para registro dos TPPs (Third-Party Providers)
que acessam as APIs do OPUS Open Finance,
registrando seus certificados criptográficos utilizados na validação de assinaturas
dos *payloads* de requisições subsequentes.

### Gestão multimarcas

Para instituições que devem disponibilizar APIs de Open Finance para diferentes marcas,
a plataforma oferece suporte nativo à convivência de múltiplas marcas em uma mesma
instalação do produto.

Com isso, marcas podem conviver no mesmo cluster Kubernetes,
beneficiando-se do compartilhamento de alguns microsserviços essenciais,
gerando economia de infraestrutura e menor complexidade operacional.

### Gestão de logs

TODO.

### Plataforma de Coleta de Métricas

A Plataforma de Coleta de Métricas (PCM) é um requisito regulatório, obrigatório,
que exige que todas as instituições participantes reportem à estrutura de governança
métricas sobre todas as chamadas de API efetuadas e/ou recebidas.
Ambas as instituições envolvidas em qualquer operação devem enviar
reportes contendo informações como endpoint acessado, data e hora do evento,
resultado recebido e tempo de resposta.

![Plataforma de Coleta de Métricas](./imagens/pcm.png)

O componente de PCM é parte integrante da plataforma OPUS Open Finance,
e executa de maneira transparente a coleta das informações necessárias e seu
envio à plataforma oficial da estrutura de governança.
Isso é possível graças à arquitetura da solução, na qual todas as chamadas
passam através de seu gateway.

Adicionalmente, o componente também agrupa os reportes para minimizar impactos
de desempenho,
mas ao mesmo tempo garantindo o envio dentro dos SLAs obrigatórios de tempestividade.
Adicionalmente, o módulo também lida com eventuais indisponibilidades da plataforma
central, armazenando os reportes não enviados até que a estrutura volte a fica disponível.

O componente de PCM da plataforma OPUS Open Finance integra-se com todos os
módulos oferecidos, isto é, os módulos de
Detentora de Conta, Transmissora de Dados, Iniciadora de Pagamentos e
Receptora de Dados.

Desta forma, não há necessidade nenhuma de desenvolvimento extra e de preocupações
com o envio de reportes. Uma vez configurado e inicializado, o módulo PCM enviará
automaticamente todos os dados necessários, minimizando impacto e garantindo conformidade
com as regulações.

### Health Check

As APIs obrigatórias de status dos serviços são implementadas pela solução,
e todas as chamadas recebidas são contabilizadas para efetuação dos
cálculos de disponibilidade que devem ser informados à estrutura de governança.

### Security e autenticação de serviços

TODO.

### Fila de eventos

TODO.

![Fila de eventos OPUS Open Finance](./imagens/eventos.png)

### Portal Backoffice

TODO.

#### Cadastro de indisponibilidade (regulatório)

TODO.

#### Registro de falhas (regulatório)

TODO.

#### Acompanhamento de SLA

TODO.

### Componentes de apoio

TODO.

#### Portal de geração de consentimentos White-label

TODO.

#### Tela de handoff White-label

TODO.

#### Aplicativo móvel com telas de autorização

TODO.

#### Connector Tester

TODO.

#### Quick Simulator

TODO.


---

- Integração de segurança
  - [Geração de Consentimento com aplicativo da instituição](consentimento/app2as/readme.md)
  - [Hybrid-flow com handoff (biblioteca javascript)](consentimento/app2as-handoff/readme.md)
- [Integração plugins Camel](integração-plugin/readme.md)
  - [Open data (Fase 1)](integração-plugin/open-data/readme.md)
  - [Discovery de recursos](integração-plugin/consent/readme.md#discovery-de-recursos-no-opus-open-banking)
  - [Financial data (Fase 2)](integração-plugin/financial-data/readme.md)
  - [Payments (Fase 3)](integração-plugin/payments/readme.md)
- [Domínios e certificados necessários](dominios-e-certificados/readme.md)
  - [Certificados do diretório central (SANDBOX)](dominios-e-certificados/tpp.md)
- [Segurança](segurança/readme.md)

## Certificação

[Roteiro para envio da certificação OpenID Foundation](certificacao/seguranca/enviando-certificacao.md)

## Ferramentas úteis

- [JSON Schema](ferramentas-auxiliares/json-schema/readme.md)
- [Connector Tester](ferramentas-auxiliares/connector-tester/readme.md)
