const fs = require('fs');
const httpGet = require('https').get;

const DEBUG = false;

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

function logInfo(err) {
    if(!DEBUG) {
        return;
    }

    try {
        fs.appendFileSync('/tmp/my3status.log', new Date().toISOString() + "-" + stringify(err) + "\n");
    } catch (err) {
    }
}

const httpCache = {};

function get(url, headers = {}) {
    headers['User-Agent'] = 'my3status';
    const urlCache = httpCache[url] || {};

    return new Promise(function (resolve, reject) {

        const eTag = urlCache.etag;
        if (eTag) {
            headers['If-None-Match'] = eTag;
        }

        httpGet(url, {
            headers: headers
        }, response => {
            logInfo({
                message: 'HTTP GET',
                cache: {
                    etag: eTag
                },
                request: {
                    url: url,
                    headers: headers,
                },
                response: {
                    statusCode: response.statusCode,
                    headers: response.headers,
                }
            });
            if (response.statusCode === 304) {
                resolve({
                    body: urlCache.response
                });
                return;
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
                // don't know why, etag header is not always using the same case....
                httpCache[url] = {
                    etag: response.headers['ETag'] || response.headers['etag'],
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
