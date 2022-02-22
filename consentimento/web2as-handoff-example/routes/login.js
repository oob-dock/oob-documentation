const express = require('express');
const router = express.Router();
const generateSignedJwt = require('../jwt/generateSignedJwt');
const asOobApi = require('../as-oob/as-oob-api');

router.post('/', async function (req, res) {
  const commandId = req.session.commandId;
  const jti = req.session.jti;
  console.log(`Started login process for commandId ${commandId} with jti ${jti}`);

  const genJwt = generateSignedJwt(buildJwtPayload(req.body, jti));
  console.log(`Generated signed JWT: ${genJwt}`);

  const putAuthenticationResponse = await asOobApi.putAuthentication(commandId, buildAuthenticationPayload(genJwt));
  const commandType = putAuthenticationResponse?.command;

  if (commandType === 'completed') {
    // Cenário 1 - Authorization Server (AS) configurado para renderização de suas telas padrão:
    // o retorno será um comando "completed"
    const redirectUrl = putAuthenticationResponse?.completedCommand?.redirect?.redirectTo;
    return res.redirect(redirectUrl);
  } else if (commandType === 'consent') {
    // Cenário 2 - Authorization Server (AS) configurado para renderização de telas customizadas:
    // retorno será um comando "consent"
    req.session.consent = putAuthenticationResponse;
    return res.redirect('/consent');
  } else {
    // Cenário 3 - Erro no processo de autenticação no Authorization Server (AS):
    // o retorno será um comando "error"
    const redirectUrl = putAuthenticationResponse?.errorCommand?.redirect?.redirectTo ?? 'https://www.opus-software.com.br/';

    if (redirectUrl.startsWith(process.env.AS_OOB_URL)) {
      // Cenário 3.a - Authorization Server (AS) configurado para renderização de suas telas padrão:
      // o aplicativo web deve realizar um redirect para a URL retornada pelo AS dentro da resposta do comando
      return res.redirect(redirectUrl);
    } else {
      // Cenário 3.b - Authorization Server (AS) configurado para renderização de telas customizadas:
      // o aplicativo web deve chamar a renderização de sua tela de erro
      return res.render('error', {
        title: 'Erro!',
        error: putAuthenticationResponse,
        redirectTo: redirectUrl,
      });
    }
  }
});

router.post('/cancel', async function (req, res) {
  const commandId = req.session.commandId;
  console.log(`Started cancel login process for commandId ${commandId}`);
  
  const putAuthenticationResponse = await asOobApi.putAuthentication(commandId, buildAuthenticationPayload());
  const redirectUrl = putAuthenticationResponse?.errorCommand?.redirect?.redirectTo ?? 'https://www.opus-software.com.br/';

  if (redirectUrl.startsWith(process.env.AS_OOB_URL)) {
    // Cenário 1 - Authorization Server (AS) configurado para renderização de suas telas padrão:
    // o aplicativo web deve realizar um redirect para a URL retornada pelo AS dentro da resposta do comando
    return res.redirect(redirectUrl);
  } else {
    // Cenário 2 - Authorization Server (AS) configurado para renderização de telas customizadas:
    // o aplicativo web deve chamar a renderização de sua tela de erro
    return res.render('error', {
      title: 'Erro!',
      error: putAuthenticationResponse,
      redirectTo: redirectUrl,
    });
  }
});

function buildJwtPayload(reqBody, jti) {
  const jwt = {
    jti: jti,
    cpf: reqBody.cpf,
    cnpj: reqBody.cnpj,
    name: reqBody.name,
  }

  if (reqBody.authExtraData) {
    jwt.authExtraData = JSON.parse(reqBody.authExtraData);
  }

  return jwt;
}

function buildAuthenticationPayload(jwt) {
  return jwt
    ? { refused: false, jwt: jwt }
    : { refused: true };
}

module.exports = router;
