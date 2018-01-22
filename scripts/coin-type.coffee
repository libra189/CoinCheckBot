fs = require 'fs'
async = require 'async'

coin_list = JSON.parse(fs.readFileSync('./data/coin_pair.json', 'utf-8'))
check_list = ['BTC']
base_url = "https://coincheck.com/api/rate/"


getDate = ->
    d = new Date
    year = d.getFullYear()
    month = d.getMonth() + 1
    day = d.getDate()
    hour = d.getHours()
    min = d.getMinutes()

    str = "#{year}年#{month}月#{day}日 "
    str += "#{hour}時#{min}分 現在"

    return str

module.exports = (robot) ->
    # 取引通貨一覧
    robot.hear /\/Coinlist/i, (msg) ->
        msg.send "取引通貨一覧"
        for key, value of coin_list
            msg.send "#{key}: #{value.name}"

    # 監視通貨追加
    robot.hear /\/Add (.*)/i, (msg) ->
        coin = msg.match[1]

        flg = false
        for key, val of coin_list
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

    # 監視通貨一覧
    robot.hear /\/List/i, (msg) ->
        msg.send "監視通貨一覧"
        for val, index in check_list
            msg.send "#{val}"

    # 現在価格
    robot.hear /\/Check/i, (msg) ->
        d = new Date
        msg.send getDate()

        get = (pair, callback) ->
            url = base_url + pair['pair']
            request = msg.http(url).get()
            setTimeout ->
                request (err, res, body) ->
                    json = JSON.parse(body)
                    callback null, "#{pair['key']}: #{json.rate}円"
            , 200 + Math.random() * 100

        pair_list = []
        for val, index in check_list
            map = {}
            map['key'] = val
            map['pair'] = coin_list[val].pair
            pair_list.push(map)

        async.map pair_list, get, (err, result) ->
            if err
                console.log err
                return -1
            message = result.join "\n"
            msg.send "#{message}"
