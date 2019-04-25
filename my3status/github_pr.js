const utils = require('./module_utils');

const user = process.env['REPO_USERNAME'];
const token = process.env['REPO_TOKEN'];


function getJson(url) {
    const headers = {
        Authorization: `Basic ${Buffer.from(user + ':' + token).toString('base64')}`
    };

    return utils.get(url, headers).then(response => JSON.parse(response.body));
}

function getRepoName(pr) {
    const repoUrl = pr['repository_url'];
    return repoUrl.substr(repoUrl.lastIndexOf('/') + 1);
}

function getPrStatuses(pr) {
    return getJson(pr.pull_request.url).then(response => {
        return response['_links'].statuses.href
    }).then(statusesUrl => {
        return getJson(statusesUrl.replace('statuses', 'status')).then(response => {
            return response.statuses;
        })
    });
}

function getStatusName(status) {
    const statusName = status.context.toLowerCase();

    if (statusName.endsWith('-pr')) {
        return 'pr';
    }

    if (statusName.includes('test')) {
        return 'qa';
    }

    switch (status.state) {
        case 'pending':
            return '?';
        case 'failure':
            return 'x';
        default:
            return '✓';
    }
}

function getStatusColor(status) {
    switch (status.state) {
        case 'pending':
            return '#FFA500';
        case 'failure':
            return '#FF0000';
        default:
            return '#00FF00';
    }
}

function mapPr(pr) {
    return getPrStatuses(pr).then(prStatuses => {
        const prNumber = pr.number;

        let output = `${getRepoName(pr)}#${prNumber}`;

        const statuses = prStatuses.map(status => {
            return `<span foreground='${getStatusColor(status)}'>${getStatusName(status)}</span>`
        });
        
        if (statuses.length > 0) {
            output += ': ' + statuses.sort().join(' ')
        }

        const labels = pr.labels.map(label => {
          return `<span foreground='#${label.color}'>${label.name[0]}</span>`
        });

        if(labels.length > 0){
	  output += ' (' + labels.sort().join('') + ')'
	}

        return {
            name: 'github_pr' + pr.id,
            full_text: output,
            markup: 'pango', // to be able for format full_text with colors
	    _onclick: `google-chrome-stable -newtab ${pr['html_url']}`,
        };
    });
}

function getPrInfo() {
    return getJson(`https://api.github.com/search/issues?q=involves:${user}+is:open+type:pr`).then(response => {
        const prs = response.items
            .filter(pr => pr.user.login === user || pr.assignees.map(a => a.login).includes(user));

        return Promise.all(prs.map(mapPr));

    }).catch(e => {
        if (e.headers && e.statusCode) {

            // this is an API error. We only log useful infos
            return {
                color: '#FF0000',
                name: 'github_pr',
                full_text: 'Error while fetching github PRs. ' + utils.logError({
                    headers: e.headers,
                    statusCode: e.statusCode,
                    statusMessage: e.statusMessage
                })
            };
        }

        // we don't know what error it is. We log all we have
        return {
            color: '#FF0000',
            name: 'github_pr',
            full_text: 'Error while fetching github PRs. ' + utils.logError(e)
        };

    });
}

module.exports = () => {
    return getPrInfo();
};
