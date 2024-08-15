// Rotas de exemplo utilizadas para renderização das telas de transição seguidas de 
// redirecionamento de rotas externas
const express = require('express');
const router = express.Router();

router.get('/confirm', async function (req, res) {
    const commandId = req.session.commandId;
    const redirectTo = req.session.redirectTo;
    console.log(`Command ${commandId} confirming consent, redirecting to: ${redirectTo}`);
    
    return res.redirect(redirectTo);
});

router.get('/cancel', async function (req, res) {
    const commandId = req.session.commandId;
    const redirectTo = req.session.redirectTo;
    console.log(`Command ${commandId} canceling consent, redirecting to: ${redirectTo}`);

    return res.redirect(redirectTo);
});

module.exports = router;
