// APIs de comunicação com o Authorization Server (AS)
const axios = require('axios');

const API_REQUEST_TIMEOUT = parseInt(process.env.API_REQUEST_TIMEOUT ?? "5000");

const axiosInstance = axios.create({
    timeout: API_REQUEST_TIMEOUT
});

const getCommand = async (commandId) => {
    try {
        const response = await axiosInstance.get(`${process.env.AS_OOB_URL}/app/commands/${commandId}`);
        return response.data;
    } catch (error) {
        throw new Error(error);
    }
};

const putAuthentication = async (commandId, payload) => {
    try {
        const response = await axiosInstance.put(`${process.env.AS_OOB_URL}/app/commands/${commandId}/authentication`, payload);
        return response.data;
    } catch (error) {
        throw new Error(error);
    }
}

const putConsent = async (commandId, payload) => {
    try {
        const response = await axiosInstance.put(`${process.env.AS_OOB_URL}/app/commands/${commandId}/consent`, payload);
        return response.data;
    } catch (error) {
        throw new Error(error);
    }
}

module.exports = {
    getCommand,
    putAuthentication,
    putConsent
}