function getZeroNumber(n) {
    if (n < 10) {
        return '0' + n;
    }

    return n;
}


module.exports = () => {
    const date = new Date();

    const formattedDate = `${date.getFullYear()}-${getZeroNumber(date.getMonth())}-${getZeroNumber(date.getDate())}`;
    const formattedTime = `${date.getHours()}:${date.getMinutes()}`;

    return {
        name: 'date',
        full_text: `${formattedDate} ${formattedTime}`,
    };
};

