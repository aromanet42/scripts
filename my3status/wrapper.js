// configuration :
//
// - items will be displayed in the order defined is this configuration array
// - each item must define a script. A script must be a function returning:
//      - a i3 block as defined in https://i3wm.org/docs/i3bar-protocol.html#_blocks_in_detail
//      - a list of i3 blocks
//      - or a Promise returning one or multiple blocks
//     Note: it is very important that the script is a function, and not directly the block or Promise.
//      (because a function can be runned multiple times, but a block or a Promise is only evaluated once)
// - each item can define an interval (in "ticks"). If absent, item will be refreshed at each "tick"


const configuration = [{
    script: require('./github_pr'),
    interval: 10
}, {
    script: require('./volume.js'),
}, {
    script: require('./battery.js'),
    interval: 5
}, {
    script: require('./date.js'),
}];

// ------------------------------------------------------
//
//    Following is the "heart" of this i3 bar
//
// ------------------------------------------------------

// printing i3bar headers
console.log("{\"version\":1, \"click_events\": true}");
console.log("[");

let firstRun = true;
let i3bar = [];

function doIt() {

    setTimeout(function () {

        // transforming item.script in a Promise
        // if it's already a Promise, this will do nothing
        // if it is not, it will 'convert' it
        // that way, we can easily wait for all Promises to be resolved with Promise.all
        const all_promises = configuration.map((item, idx) => {
            if (item.interval) {
                if (!item.remaining || item.remaining === 0) {
                    item.remaining = item.interval;
                    return Promise.resolve(item.script());
                } else {
                    item.remaining--;
                    return Promise.resolve(item.cache)
                }
            }

            return Promise.resolve(item.script());
        });

        const prefix = firstRun ? "" : ",";

        Promise.all(all_promises).then(blocks => {
	    let newI3bar = [];
            blocks.forEach((block, idx) => {
                configuration[idx].cache = block;

                if (Array.isArray(block)) {
                    newI3bar = newI3bar.concat(block);
                } else {
                    newI3bar.push(block);
                }
            });

	    // updating i3bar once all calculations are done
	    i3bar = newI3bar;
            console.log(prefix + JSON.stringify(i3bar));

            firstRun = false;
            doIt();
        });

    }, 1000);
}

// listening to stdin to handle click events
const stdin = process.stdin;
const exec = require('child_process').exec;
const logError = require('./module_utils').logError;

stdin.resume();
stdin.on('data', chunk => {
  // remove leading '[' or ','
  const cleanedChunk = chunk.toString().replace(/^\[/, '').replace(/^,/, '');
  const jsonChunk = JSON.parse(cleanedChunk);

  const clickedItem = i3bar.find(i => i.name === jsonChunk.name);

  if(clickedItem) {
    const command = clickedItem['_onclick'];

    if(command) {
      exec(command, function(err) {
	if(err) {
	  logError({
	    message: 'Error while executing command',
	    command: command,
	    error: err,
	  });
	}
      });
    } else {
      logError(`Item "${clickedItem.name}" was clicked but no '_onclick' command was found`);
    }

  } else {
    logError({
      ...jsonChunk,
      errorMessage: 'Could not find i3bar item',
    });
  }

});

doIt();
