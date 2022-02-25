const jwt = require('jsonwebtoken');

// Gera e assina um JWT com os claims necessários a ser enviado na API de autenticação para o Authorization Server (AS)
function generateSignedJwt(payload) {
    try {
        const genJwt = jwt.sign(payload, process.env.JWT_PRIVATE_KEY, 
            { 
                algorithm: 'RS256',
                header: {
                    "alg": "RS256",
                    "kid": process.env.JWT_KID
                }
            }
        );
        return genJwt;
    } catch (error) {
        throw new Error(`Error generating and signing JWT: ${error}`);
    }
}

module.exports =  generateSignedJwt;