fs = require('fs')
pair = JSON.parse(fs.readFileSync('./data/coin_pair.json', 'utf-8'))
check_list = []

module.exports = (robot) ->
    robot.hear /\/Coinlist/i, (msg) ->
        msg.send "取引通貨一覧"
        for key, value of pair
            msg.send "#{key}: #{value.name}"

    robot.hear /\/Add (.*)/i, (msg) ->
        coin = msg.match[1]

        flg = false
        for key, val of pair
            if (key is coin) or (val.name is coin)
                flg = true
                break

        if flg
            if key in check_list
                msg.send "#{coin}は既に監視済みです"
            else
                check_list.push(key)
                msg.send "#{coin}を監視リストに追加しました"
        else
            msg.send "取引していません"

    robot.hear /\/List/i, (msg) ->
        for val, index in check_list
            msg.send "#{val}"
