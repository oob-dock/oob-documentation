# Roteiro para envio da certificação OpenID Foundation

O roteiro para envio da certificação requer alguma atenção no preparo dos
artefatos a serem enviados à OpenID Foundation. Compilamos um roteiro com o
passo a passo para facilitar o preparo de tais artefatos.

A certificação em si é composta pelo teste de conformidade de DCR
`Brazil Dynamic Client Registration Authorization server test` e pelo menos um
dos profiles FAPI possíveis para o Open Banking Brazil:

- `BR-OB Adv. OP w/ MTLS`
- `BR-OB Adv. OP w/ Private Key`
- `BR-OB Adv. OP w/ MTLS, PAR`
- `BR-OB Adv. OP w/ Private Key, PAR`
- `BR-OB Adv. OP w/ MTLS, JARM`
- `BR-OB Adv. OP w/ Private Key, JARM`
- `BR-OB Adv. OP w/ MTLS, PAR, JARM`
- `BR-OB Adv. OP w/ Private Key, PAR, JARM`

É pré-requisito ter o ambiente que será certificado passando nos testes de
conformidade sem nenhum erro, os warnings são permitidos.

## 1. Preenchendo o OpenID-Certification-of-Conformance

É necessário preencher o documento `OpenID-Certification-of-Conformance` para
cada teste, as recomendações para ambos os documentos são:

- O certificado deve ser assinado por algum funcionário da organização, não pode
ser terceiro. [Link de referência](https://openid.net/certification/op_submission/#:~:text=The%20document%20can%20be%20signed%20by%20any%20authorized%20person%20who%20actually%20works%20for%20the%20implementer)
- A assinatura pode ser uma assinatura tradicional ou eletrônica. [Link de referência](https://openid.net/certification/op_submission/#:~:text=It%20can%20be%20a%20regular%20signature%20or%20an%20electronic%20one%20such%20as%20Docusign)
- As pessoas de contato podem ser funcionários da organização ou terceiros
- Não é necessário preencher o apêndice.
- Os arquivos devem ser no formato PDF com o nome
 `OpenID-Certification-of-Conformance.pdf`, cuidado para não inverter os
 arquivos ao gerar os pacotes de certificação

Um arquivo Word com o template para preenchimento está disponível [no site da OpenID](https://openid.net/wordpress-content/uploads/2021/07/OpenID-Certification-of-Conformance.docx).
Os valores de referência para o preenchimento são:

### DCR

| Campos                             | Valor                                                 | Exemplo                             |
| ---------------------------------- | ----------------------------------------------------- | ----------------------------------- |
| Name of Entity ("Implementer")     | \<Nome da organização\>                               | Opus Software                       |
| Software or Service ("Deployment") | Opus Open Banking v1                                  | Opus Open Banking v1                |
| OpenID Conformance Profile         | BR-OB Adv. OP DCR                                     | BR-OB Adv. OP DCR                   |
| Conformance Test Suite Software    | www.certification.openid.net <versão-do-certificador> | www.certification.openid.net 4.1.22 |
| Test Date                          | <Data-inglês>                                         | August 13, 2021                     |

### FAPI

| Campos                             | Valor                                                 | Exemplo                             |
| ---------------------------------- | ----------------------------------------------------- | ----------------------------------- |
| Name of Entity ("Implementer")     | \<Nome da organização\>                               | Opus Software                       |
| Software or Service ("Deployment") | Opus Open Banking v1                                  | Opus Open Banking v1                |
| OpenID Conformance Profile         | BR-OB Adv. OP w/ Private Key, PAR                     | BR-OB Adv. OP w/ Private Key, PAR   |
| Conformance Test Suite Software    | www.certification.openid.net <versão-do-certificador> | www.certification.openid.net 4.1.22 |
| Test Date                          | <Data-inglês>                                         | August 13, 2021                     |

## 2. Preparando os arquivos para envio

A geração do arquivo da certificação para envio deve ser feita para os testes DCR e FAPI, cada um utilizando o arquivo `OpenID-Certification-of-Conformance.pdf` adequado.

Os passos para obtenção do arquivo Zip da certificação:

1. Tenha a execução dos testes DCR e FAPI em <htps://www.certification.openid.net> com 
  seu usuário
2. Acesse o link "View all available test plans" para consultar todas as 
   execuções realizadas com seu usuário no certificador.
3. Clique no "View plan" do teste que deseja gerar o pacote de certificação e 
   depois em "Certification Package"
4. Faça upload do arquivo "OpenID-Certification-Terms-and-Conditions.pdf", esse
   arquivo pode ser obtido no site [OpenID Foundation](https://openid.net/wordpress-content/uploads/2019/03/OpenID-Certification-Terms-and-Conditions.pdf)
   e não requer nenhuma alteração
5. Faça upload do arquivo "OpenID-Certification-of-Conformance.pdf"
   correspondente ao teste gerado na etapa "Preenchendo o OpenID-Certification-of-Conformance"
6. Clicar em "Prepare Certification Package" e fazer download do arquivo ZIP.
7. Renomear o arquivo zip para o padrão exigido para envido da certificação do
   teste. Cada teste possui seu padrão de nomenclatura:

| Teste | Padrão                                                                                   | Exemplo                                                                           |
| ----- | ---------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| DCR   | <Nome-Organização>-Opus_Open_Banking_v1-BR-OB-Adv-OP-DCR-<Data-inglês>.zip               | Opus_Software-Opus_Open_Banking_v1-BR_OB_Adv_OP_DCR-14-Aug-2021.zip               |
| FAPI  | <Nome-Organização>-Opus_Open_Banking_v1-BR_OB_Adv_OP_w_Private-Key_PAR-<Data-inglês>.zip | Opus_Software-Opus_Open_Banking_v1-BR_OB_Adv_OP_w_Private-Key_PAR-14-Aug-2021.zip |

## 3. Enviando os arquivos de certificação

Em posse dos dois arquivos Zips já renomeados, é necessário realizar o envio
para a OpenID através do link <https://openid.atlassian.net/servicedesk/customer/portal/3/group/3/create/10016>.

O formulário para envio de ser preenchido com os seguintes valores:

| Campo                        | Valor                                            | Exemplo                                          |
| ---------------------------- | ------------------------------------------------ | ------------------------------------------------ |
| Summary                      | \<Nome da Organização> - Opus Open Banking v1    | Opus Software - Opus Open Banking v1             |
| Test Results                 | My tests have all passed (or have only warnings) | My tests have all passed (or have only warnings) |
| Certification Payment Status | \<escolher o modelo de pagamento utilizado>      | -                                                |
| Certification Zip File       | Anexar os arquivos Zip gerados                   | -                                                |
| Email confirmation to        | <email do responsável na organização>            | patrick@opus-software.com.br                     |

Um email de confirmação chegará para o email informado no campo "Email
confirmation to" após o envio. A OpenID Foundation deve processar a solicitação
em até 3 dias. Em casos de demora, seguir as instruções do site da
[OpenID](https://openid.net/certification/op_submission/#:~:text=If%20you%20don%E2%80%99t%20receive%20any%20further%20response%20within%203%20working%20days)
