const utils = require('./module_utils');

const user = process.env['REPO_USERNAME'];
// this token is defined in .xsessionrc
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
            let statuses = response.statuses.map(s => {
                return {
                    name: getStatusName(s.context.toLowerCase(), s.state),
                    state: s.state,
                }
            });

            if (pr.draft) {
                // for Draft PRs, only display build result. Others statuses (QA, etc) are not relevant and take too much place
                statuses = statuses.filter(status => status.name === 'pr');
            }

            return statuses;
        })
    }).catch(() => {
        return [];
    });
}

function getStatusName(statusName, state) {
    if (statusName.endsWith('-pr')) {
        return 'pr';
    }

    if (statusName.includes('test')) {
        return 'qa';
    }

    switch (state) {
        case 'pending':
            return '?';
        case 'failure':
            return 'x';
        default:
            return '✓';
    }
}

function mapCheckStatus(check) {
    if (!check.conclusion) {
        return 'pending';
    }
    return check.conclusion;
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

function getPrChecks(pr) {
    return getJson(pr.pull_request.url).then(fullPr => {
        const commit = fullPr.head.sha;
        return getJson(`${fullPr.head.repo.url}/commits/${commit}/check-suites`).then(response => {
            const checkSuites = response.check_suites
                .filter(c => c.latest_check_runs_count > 0);

            if (!checkSuites) {
                return [];
            }

            // pr can have multiple checkSuites if C1 was pushed, then C2, then C2 was reverted => C1 has 2 check suites, for each time it was the "last commit"
            // we need only the most recent
            let lastCheckSuite = checkSuites
                .sort((c1, c2) => c2.created_at.localeCompare(c1.created_at))[0];

            const status = mapCheckStatus(lastCheckSuite);
            return {
                name: getStatusName(lastCheckSuite.node_id, status),
                state: status,
            };
        });
    }).catch(() => {
        return [];
    });
}

function mapPr(pr) {
    return Promise.all([
        getPrStatuses(pr),
        getPrChecks(pr),
    ]).then(([prStatuses, checks]) => {
        const prNumber = pr.number;

        let output = `${getRepoName(pr)}#${prNumber}`;
        if (pr.draft) {
            output = `<span foreground='#666'>${output}</span>`
        }

        const statuses = prStatuses.concat(checks).map(status => {
            return `<span foreground='${getStatusColor(status)}'>${status.name}</span>`
        });

        if (statuses.length > 0) {
            output += ': ' + statuses.sort().join(' ')
        }

        const labels = pr.labels.map(label => {
            return `<span foreground='#${label.color}'>${label.name[0]}</span>`
        });

        if (labels.length > 0) {
            output += ' (' + labels.sort().join('') + ')';
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
