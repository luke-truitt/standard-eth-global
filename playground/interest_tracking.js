const axios = require('axios');
const conventionalChangelogPresetLoader = require('conventional-changelog-preset-loader');
const RATIO = 10**27;
const SECONDS_PER_YEAR = 60*60*24*365.25

function calculate_rate(block1, block2) {
    const index_2 = block2.index;
    const index_1 = block1.index;
    const time_2 = block2.timestamp;
    const time_1 = block1.timestamp;
    const time_diff = (time_2 - time_1);
    const rate_ratio = (index_2/index_1)-1;
    const time_ratio = rate_ratio/time_diff;
    return time_ratio * SECONDS_PER_YEAR;
}
async function calc_avg_rate() {
    const num_blocks = 100;
    let rateHistory = await getHistory(num_blocks);
    const most_recent_block = rateHistory[0];
    const most_recent_time = most_recent_block.timestamp;
    const one_day_ago = most_recent_time - 24*60*60;
    let j = num_blocks - 1;
    while(one_day_ago > rateHistory[j].timestamp) {
        j = j - 1
    }
    const relevantTimes = [rateHistory[0], rateHistory[j]]
    average_rate = calculate_rate(relevantTimes[1], relevantTimes[0])
    return average_rate
}

async function getHistory(numRates) {
    const max_i = numRates/100
    let rateHistory = []
    let i = 0
    while(i < max_i) {
        const skip_size = i * 100
        const body = {"query": `{reserve(id: \"0xc2132d05d31c914a87c6611c10748aeb04b58e8f0xd05e3e715d945b59290df0ae8ef85c1bdb684744\") { id name paramsHistory(first: 100, skip: ${skip_size}, orderDirection: desc, orderBy: timestamp) { id variableBorrowRate utilizationRate liquidityRate liquidityIndex timestamp } } }`}
        await axios.post("https://api.thegraph.com/subgraphs/name/aave/aave-v2-matic", body)
        .then(function (response) {
            paramHistory = response.data.data.reserve.paramsHistory;
            paramHistory.map((param, idx) => {
                rateHistory.push({'timestamp': param.timestamp, 'rate': param.liquidityRate, 'index': param.liquidityIndex})
            })
        })
        .catch(function (error) {
            console.log(error);
        });
        i = i + 1;
    }
    return rateHistory
}


calc_avg_rate()