# Guide for Submitting OpenID Foundation Certification

The guide for submitting the certification requires some attention in preparing the artifacts to be sent to the OpenID Foundation. We have compiled a step-by-step guide to facilitate the preparation of such artifacts.

The certification itself consists of the DCR conformance test `Brazil Dynamic Client Registration Authorization server test` and at least one of the possible FAPI profiles for Open Banking Brazil:

- `BR-OB Adv. OP w/ MTLS`
- `BR-OB Adv. OP w/ Private Key`
- `BR-OB Adv. OP w/ MTLS, PAR`
- `BR-OB Adv. OP w/ Private Key, PAR`
- `BR-OB Adv. OP w/ MTLS, JARM`
- `BR-OB Adv. OP w/ Private Key, JARM`
- `BR-OB Adv. OP w/ MTLS, PAR, JARM`
- `BR-OB Adv. OP w/ Private Key, PAR, JARM`

It is a prerequisite that the environment to be certified passes the conformance tests without any errors; warnings are allowed.

## 1. Filling Out the OpenID-Certification-of-Conformance

It is necessary to fill out the `OpenID-Certification-of-Conformance` document for each test. The recommendations for both documents are:

- The certificate must be signed by an employee of the organization, not a third party. [Reference link](https://openid.net/certification/op_submission/#:~:text=The%20document%20can%20be%20signed%20by%20any%20authorized%20person%20who%20actually%20works%20for%20the%20implementer)
- The signature can be a traditional or electronic signature. [Reference link](https://openid.net/certification/op_submission/#:~:text=It%20can%20be%20a%20regular%20signature%20or%20an%20electronic%20one%20such%20as%20Docusign)
- Contact persons can be employees of the organization or third parties.
- It is not necessary to fill out the appendix.
- The files must be in PDF format with the name `OpenID-Certification-of-Conformance.pdf`. Be careful not to mix up the files when generating the certification packages.

A Word file with the template for completion is available [on the OpenID website](https://openid.net/wordpress-content/uploads/2021/07/OpenID-Certification-of-Conformance.docx). The reference values for completion are:

### DCR

| Fields                             | Value                                                 | Example                             |
| ---------------------------------- | ----------------------------------------------------- | ----------------------------------- |
| Name of Entity ("Implementer")     | \<Organization Name\>                                 | Opus Software                       |
| Software or Service ("Deployment") | Opus Open Finance v1.31                              | Opus Open Finance v1.31                |
| OpenID Conformance Profile         | BR-OB Adv. OP DCR                                     | BR-OB Adv. OP DCR                   |
| Conformance Test Suite Software    | www.certification.openid.net <certifier-version>      | www.certification.openid.net 4.1.22 |
| Test Date                          | <Date-English>                                        | August 13, 2024                     |

### FAPI

| Fields                             | Value                                                 | Example                             |
| ---------------------------------- | ----------------------------------------------------- | ----------------------------------- |
| Name of Entity ("Implementer")     | \<Organization Name\>                                 | Opus Software                       |
| Software or Service ("Deployment") | Opus Open Finance v1.31                               | Opus Open Finance v1.31                |
| OpenID Conformance Profile         | BR-OB Adv. OP w/ Private Key, PAR                     | BR-OB Adv. OP w/ Private Key, PAR   |
| Conformance Test Suite Software    | www.certification.openid.net <certifier-version>      | www.certification.openid.net 4.1.22 |
| Test Date                          | <Date-English>                                        | August 13, 2024                     |

## 2. Preparing the Files for Submission

The generation of the certification file for submission must be done for the DCR and FAPI tests, each using the appropriate `OpenID-Certification-of-Conformance.pdf` file.

The steps to obtain the certification Zip file:

1. Have the DCR and FAPI tests executed on <https://www.certification.openid.net> with your user.
2. Access the link "View all available test plans" to consult all executions performed with your user in the certifier.
3. Click on "View plan" of the test you want to generate the certification package and then on "Certification Package".
4. Upload the "OpenID-Certification-Terms-and-Conditions.pdf" file, which can be obtained on the [OpenID Foundation website](https://openid.net/wordpress-content/uploads/2019/03/OpenID-Certification-Terms-and-Conditions.pdf) and requires no changes.
5. Upload the "OpenID-Certification-of-Conformance.pdf" file corresponding to the test generated in the "Filling Out the OpenID-Certification-of-Conformance" step.
6. Click on "Prepare Certification Package" and download the ZIP file.
7. Rename the ZIP file to the required standard for certification submission. Each test has its naming standard:

| Test  | Standard                                                                                   | Example                                                                           |
| ----- | ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------- |
| DCR   | <Organization-Name>-Opus_Open_Banking_v1-BR-OB-Adv-OP-DCR-<Date-English>.zip               | Opus_Software-Opus_Open_Banking_v1-BR_OB_Adv_OP_DCR-14-Aug-2021.zip               |
| FAPI  | <Organization-Name>-Opus_Open_Banking_v1-BR_OB_Adv_OP_w_Private-Key_PAR-<Date-English>.zip | Opus_Software-Opus_Open_Banking_v1-BR_OB_Adv_OP_w_Private-Key_PAR-14-Aug-2021.zip |

## 3. Submitting the Certification Files

With the two ZIP files already renamed, it is necessary to submit them to OpenID through the link <https://openid.atlassian.net/servicedesk/customer/portal/3/group/3/create/10016>.

The submission form should be filled out with the following values:

| Field                        | Value                                            | Example                                          |
| ---------------------------- | ------------------------------------------------ | ------------------------------------------------ |
| Summary                      | \<Organization Name\> - Opus Open Finance v1.31  | Opus Software - Opus Open Finance v1.31             |
| Test Results                 | My tests have all passed (or have only warnings) | My tests have all passed (or have only warnings) |
| Certification Payment Status | \<choose the payment model used\>                | -                                                |
| Certification Zip File       | Attach the generated ZIP files                   | -                                                |
| Email confirmation to        | <responsible person's email in the organization> | patrick@opus-software.com.br                     |

A confirmation email will be sent to the email provided in the "Email confirmation to" field after submission. The OpenID Foundation should process the request within 3 days. In case of delays, follow the instructions on the [OpenID website](https://openid.net/certification/op_submission/#:~:text=If%20you%20don%E2%80%99t%20receive%20any%20further%20response%20within%203%20working%20days).
