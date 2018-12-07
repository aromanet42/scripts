const fs = require('fs');
const httpGet = require('https').get;

function stringify(o) {
    // Note: cache should not be re-used by repeated calls to JSON.stringify.
    let cache = [];
    const result = JSON.stringify(o, function (key, value) {
        if (typeof value === 'object' && value !== null) {
            if (cache.indexOf(value) !== -1) {
                // Duplicate reference found
                try {
                    // If this value does not reference a parent it can be deduped
                    return JSON.parse(JSON.stringify(value));
                } catch (error) {
                    // discard key if value cannot be deduped
                    return;
                }
            }
            // Store value in our collection
            cache.push(value);
        }
        return value;
    });
    cache = null; // Enable garbage collection

    return result;
}


function logError(err) {
    try {
        fs.appendFileSync('/tmp/my3status.error', new Date().toISOString() + "-" + stringify(err) + "\n");
        return 'See /tmp/my3status.error file';
    } catch (err) {
        return err;
    }
}

const httpCache = {};

function get(url, headers = {}) {
    headers['User-Agent'] = 'my3status';

    return new Promise(function (resolve, reject) {
        const urlCache = httpCache[url] || {};

        const eTag = urlCache.etag;
        if (eTag) {
            headers['If-None-Match'] = eTag;
        }

        httpGet(url, {
            headers: headers
        }, response => {
            if (response.statusCode === 304) {
                return urlCache.response;
            }

            if (response.statusCode !== 200) {
                reject(response);
                return;
            }

            let data = "";
            response.on("data", function (d) {
                data = data + d;
            });
            response.on("end", function () {
                httpCache[url] = {
                    etag: response.headers['ETag'],
                    response: data
                };

                resolve({
                    ...response,
                    body: data,
                });
                return;
            });
        }).on('error', function (e) {
            reject(e);
        });
    });
}


module.exports = {
    logError,
    get,
};
