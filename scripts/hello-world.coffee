module.exports = (robot) ->
    robot.respond /Hello/i, (msg) ->
        msg.send "HelloWorld"