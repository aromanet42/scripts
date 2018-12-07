var exec = require('child_process').exec;

function amixer() {
    return new Promise(function (resolve, reject) {
        exec('amixer', function (err, stdout, stderr) {
            resolve(stdout);
        })
    });
}

var reInfo = /[a-z][a-z ]*: Playback [0-9-]+ \[([0-9]+)%\] (?:[[0-9.-]+dB\] )?\[(on|off)\]/i;

function parseInfo(data) {
    var result = reInfo.exec(data);

    if (result === null) {
        throw new Error('Alsa Mixer Error: failed to parse output')
    }

    return {volume: parseInt(result[1], 10), muted: (result[2] === 'off')}
}

function getInfo() {
    return amixer('sget', 'Master').then(function (data) {
        return parseInfo(data)
    });
}

module.exports = () => {
    return getInfo().then(function (info) {
        if (info.muted) {
            return {
                name: 'volume',
                full_text: '🔇' + info.volume + '% (muted)',
                color: '#fceebd'
            };
        } else {
            return {
                name: 'volume',
                full_text: '🔊 ' + info.volume + '%',
                color: '#FFFFFF'
            };
        }
    })
};
