const exec = require('child_process').exec;

function amixer(cmd, name) {
    return new Promise(function (resolve, reject) {
        exec(`amixer ${cmd} ${name}`, function (err, stdout, stderr) {
            resolve(stdout);
        })
    });
}

const reInfo = /[a-z][a-z ]*: [A-Za-z]+ [0-9-]+ \[([0-9]+)%\] (?:[[0-9.-]+dB\] )?\[(on|off)\]/i;

function parseInfo(data) {
    const result = reInfo.exec(data);

    if (result === null) {
        throw new Error('Alsa Mixer Error: failed to parse output')
    }

    return {volume: parseInt(result[1], 10), muted: (result[2] === 'off')}
}

function getInfo(name) {
    return amixer('sget', name).then(function (data) {
        return parseInfo(data);
    });
}


module.exports = () => {
    return Promise.all([getInfo('Master'), getInfo('Capture')]).then(info => {
        const volume = info[0];
        const micro = info [1];

        let text = '';
        if (volume.muted) {
            text = '🔇' + volume.volume + '% (muted)';
        } else {
            text = '🔊 ' + volume.volume + '%';
        }

        text += ' - 🎤 '
        text += micro.muted ? 'OFF' : 'ON';

        return {
            name: 'volume',
            full_text: text,
            color: '#FFFFFF'
        };
    });
};
