pair = require('../data/coin_pair.json')

module.exports = (robot) ->
    robot.hear /\/CoinList/i, (msg) ->
        msg.send "略語: 名称[通貨ペア]"
        for key, value of pair
            msg.send "#{key}: #{value.name}[#{value.pair}]"
