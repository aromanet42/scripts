const utils = require('../my3status/module_utils');

const reposToKeepWatching = [
    'tools-dev-info',
    'tools-api-docs',
    'mirakl-compose',
    'emma',
    'tools-algolia',
    'tools-translation',
  'app-calliope',
  'calliope-translation-server',
  'app-candydates',
  'tools-mirakl-university',
  'tools-checklist',
  'app-countdown',
  'github-actions',
    'app-mirakl-status',
];


const user = process.env['REPO_USERNAME'];
const token = process.env['REPO_TOKEN'];

const headers = {
    Authorization: `Basic ${Buffer.from(user + ':' + token).toString('base64')}`
};


function extractNextLink(linkHeader) {
    if (typeof linkHeader === 'undefined') {
        return undefined;
    }

    const links = {};
    linkHeader.split(',').map((relLink) => {
        const datas = relLink.split(';');
        links[datas[1]] = datas[0];
    });

    const nextLink = links[' rel="next"'];
    if (nextLink) {
        const regex = /[<>]/g;
        return nextLink.replace(regex, '');
    }

    return undefined;
}

function get(url, json) {

    return utils.get(url, headers).then(response => {
        const data = {};

        if (json) {
            data.data = JSON.parse(response.body);
        }

        const links = response.headers['link'];
        // <https://api.github.com/user/subscriptions?page=2>; rel="next", <https://api.github.com/user/subscriptions?page=8>; rel="last"
        if (links) {
            const nextLinkHeader = extractNextLink(links);
            console.log("nextLinkHeader", nextLinkHeader)
            if (nextLinkHeader) {
                data.nextLink = nextLinkHeader;
            }
        }


        return data;
    });
}

const unwatch = url => {
    return get(url, true).then(response => {
        const repos = response.data;

        let unwatchingRepos = repos
            .filter(r => r.owner.login === 'mirakl')
            .filter(r => !reposToKeepWatching.includes(r.name))
            .map(r => {
                return utils.deleteApi(r.url + '/subscription', headers).then(() => {
                    console.log("Unsubscribed from ", r.full_name);
                    return true;
                });
            });
        console.log(`About to unwatch ${unwatchingRepos.length} repos`);

        return Promise.all(unwatchingRepos).then(() => {
            if (response.nextLink) {
                return unwatch(response.nextLink).then(nexts => {
                    return unwatchingRepos.length + nexts;
                });
            }
            return unwatchingRepos.length;
        });
    });
}

unwatch('https://api.github.com/user/subscriptions').then(nb => {
    console.log(`unwatched from ${nb} repositories`);
}).catch(err => {
    console.error("Got an error", err);
});
