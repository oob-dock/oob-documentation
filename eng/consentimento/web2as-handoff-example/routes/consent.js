const express = require('express');
const router = express.Router();
const asOobApi = require('../as-oob/as-oob-api');

router.get('/', async function (req, res) {
  console.log("Retrieving consent info from session");
  const consent = req.session.consent;
  res.send(consent);
});

router.post('/', async function (req, res) {
  const commandId = req.session.commandId;
  const selectedIds = req.body.selectedIds.replace(/\s/g, '').split(',');
  validateSelectedIds(res, selectedIds);
  console.log(`Selected resource IDs for command ${commandId}: ${selectedIds}`);

  const putConsentResponse = await asOobApi.putConsent(commandId, buildConsentPayload(selectedIds));
  const commandType = putConsentResponse?.command;

  if (commandType === "completed") {
    // Cenário 1 - Retorno de um comando "completed" indica que o fluxo foi finalizado e o redirect
    // para a tela de transição pode ser chamado
    req.session.redirectTo = putConsentResponse?.completedCommand?.redirect?.redirectTo;
    return res.redirect('/redirect?action=confirm');
  } else {
    // Cenário 2 - Retorno de um comando "error" indica que houve algum problema durante o processo
    // de seleção dos recursos, ocorre a renderização da tela de erro
    const errorCommand = putConsentResponse?.errorCommand;
    const redirectUrl = errorCommand?.redirect?.redirectTo ?? "https://www.opus-software.com.br/";
    return res.render('error', {
      title: 'Erro!',
      error: errorCommand,
      redirectTo: redirectUrl
    });
  }
});

router.post('/cancel', async function (req, res) {
  const commandId = req.session.commandId;
  console.log(`Canceling consent for command ${commandId}`);

  // Cenário de recusa do consentimento, seguido da renderização da tela de transição e
  // posterior redirecionamento de volta ao TPP
  const putConsentResponse = await asOobApi.putConsent(commandId, buildConsentPayload());
  const redirectUrl = putConsentResponse?.errorCommand?.redirect?.redirectTo ?? "https://www.opus-software.com.br/";

  req.session.redirectTo = redirectUrl;
  return  res.redirect('/redirect?action=cancel');
});

router.get('/redirect/:action', async function (req, res) {
  const consent = req.session.consent;
  res.send({
    tpp: consent?.tpp || '',
    brand: consent?.consentCommand?.brand || '',
    redirectUrl: `/api/redirect/${req.params.action}`,
  });
});

function validateSelectedIds(res, selectedIds) {
  if (!selectedIds || selectedIds[0] === '') {
    res.render('error', {
      title: 'Erro!',
      error: { 
        message: 'Nenhum ID de recurso informado.' 
      },
      redirectTo: 'https://www.opus-software.com.br/'
    });
  }
}

function buildConsentPayload(selectedIds) {
  return selectedIds 
    ? { refused: false, selectedResources: selectedIds }
    : { refused: true };
}

module.exports = router;