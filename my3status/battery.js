var exec = require('child_process').exec;

function batteryInfo() {
    return new Promise(function (resolve, reject) {
        exec('upower -i /org/freedesktop/UPower/devices/battery_BAT0', function (err, stdout, stderr) {
            resolve(stdout);
        })
    });
}


function getBatteryState(state, percentage) {
    if (state === 'fully-charged' || state === 'charging') {
        return "\uF1E6";
    } else if (percentage > 90) {
        return "\uF240";
    } else if (percentage > 75) {
        return "\uF241";
    } else if (percentage > 50) {
        return "\uF242";
    } else if (percentage > 25) {
        return "\uF243";
    }
    return "\uF244";
}

const stateRegex = /state:\s*([a-z-]+)/i;
const percentageRegex = /percentage:\s*([0-9]+%)/i;

function parseInfo(data) {
    const stateResult = stateRegex.exec(data);
    const percentageResult = percentageRegex.exec(data);

    if (stateResult === null || percentageResult === null) {
        return {
            name: 'battery',
            color: '#FF0000',
            full_text: 'Error while retrieving battery info'
        }
    }

    return {
        name: 'battery',
        full_text: getBatteryState(stateResult[1], percentageResult[1]),
    }
}

function getInfo() {
    return batteryInfo().then(function (data) {
        return parseInfo(data)
    });
}

module.exports = () => {
    return getInfo();
};
