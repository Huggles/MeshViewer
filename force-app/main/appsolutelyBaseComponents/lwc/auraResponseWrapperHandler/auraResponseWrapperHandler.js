/**
 * Created by jaapbranderhorst on 04/07/2020.
 */

const handleResponse = (auraResponseWrapper) => {
    if (!auraResponseWrapper) {
        return Promise.reject('No responsewrapper present');
    }
    if (!auraResponseWrapper.state) {
        return Promise.reject('No state in response wrapper');
    }
    if (auraResponseWrapper.state === 'SUCCESS') {
        return Promise.resolve(auraResponseWrapper.data); // void methods just return undefined
    }
    if (auraResponseWrapper.state === 'ERROR') {
        return Promise.reject(auraResponseWrapper.error);
    }
}

export {handleResponse}