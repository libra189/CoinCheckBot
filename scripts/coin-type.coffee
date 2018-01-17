pair = require('../data/coin_pair.json')

module.exports = (robot) ->
    robot.hear /\/Coinlist/i, (msg) ->
        msg.send "取引通貨一覧"
        for key, value of pair
            msg.send "#{key}: #{value.name}"
