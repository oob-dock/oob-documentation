#!/usr/bin/env node

const https = require('https');

function makeRequest(url, orgIds, retryCount) {
    https.get(url, (response) => {
        let data = '';

        response.on('data', (chunk) => {
            data += chunk;
        });

        response.on('end', () => {
            const participants = JSON.parse(data);
            console.log('----------------------------------------------');

            orgIds.map((orgId) => {
                const participant = participants.find((p) => p.OrganisationId === orgId);
                if (!participant) {
                    console.log(`Org ID ${orgId} Not found`);
                    console.log('----------------------------------------------');
                } else {
                    console.log(`Org ID: ${orgId}`);
                    console.log(`Parent Organization: ${!participant?.ParentOrganisationReference? "N/A" : participant?.ParentOrganisationReference}`);
                    console.log('----------------------------------------------');
                }
            });
        });
    }).on('error', error => {
        console.error(`Error: ${error.message}`);

        if (retryCount > 0) {
            console.log(`Retrying request. Retry count: ${retryCount}`);
            makeRequest(url, orgIds, retryCount - 1);
        } else {
            console.log("Not possible to get parent organizations for ids informed. Check if Directory API is responding and try again later...");
        }
    }).end();
}

async function getParentOrganisationReferences(orgIds) {
    const url = 'https://data.directory.openbankingbrasil.org.br/participants';
    makeRequest(url, orgIds, 3);
}

const orgIds = process.argv.slice(2);
getParentOrganisationReferences(orgIds);