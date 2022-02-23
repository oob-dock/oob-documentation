const express = require('express');
const router = express.Router();
const asOobApi = require('../as-oob/as-oob-api');

// Rota utilizada para obter o commandId enviado como fragment pela chamada 
// do Authorization Server (AS). Em seguida o AS é chamado para retornar mais 
// informações sobre o command em questão. Seu identificador e jti são armazenados
// em uma sessão do request para uso posterior no fluxo
router.post('/', async function (req, res) {
  const commandId = req.body.commandid;
  console.log(`Received commandId: ${commandId}`);
  req.session.commandId = commandId;

  console.log(`Calling getCommand for commandId ${commandId}`);
  const getCommandResponse = await asOobApi.getCommand(commandId);

  const jti = getCommandResponse.authenticateCommand.jti;
  console.log(`Persisting jti ${jti} on commmand id ${commandId} session`);
  req.session.jti = jti;

  console.log('Redirecting to /login');
  res.redirect('/login');
});

module.exports = router;
