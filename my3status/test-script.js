const github = require('./github_pr');

github().then(data => {
    console.log(data);
});