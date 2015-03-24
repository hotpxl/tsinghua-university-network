request = require('request').defaults
  jar: true
md5 = require 'crypto-js/md5'
cheerio = require 'cheerio'

exports.login = login = (username, password, callback) ->
  form =
    drop: 0
    type: 1
    n: 100
    username: username
    password: md5(password).toString()
  request.post
    url: 'http://net.tsinghua.edu.cn/cgi-bin/do_login'
    form: form
    (error, response, body) ->
      callback(error) if error
      callback(response) if response.statusCode != 200
      if /^\d+/.test body
        usage = parseFloat body.split(',')[2]
        callback null, usage / (10 ** 9)
      else
        callback body

exports.getActiveConnections = getActiveConnections = (username, password, callback) ->
  form =
    action: 'login'
    user_login_name: username
    user_password: md5(password).toString()
  request.post
    url: 'http://usereg.tsinghua.edu.cn/do.php'
    form: form
    (error, response, body) ->
      callback(error) if error
      callback(response) if response.statusCode != 200 or response.statusMessage != 'OK'
      request.get 'http://usereg.tsinghua.edu.cn/online_user_ipv4.php', (error, response, body) ->
        callback(error) if error
        callback(response) if response.statusCode != 200
        $ = cheerio.load body
        ret = []
        $('.maintd input').each (_, ele) ->
          match = /'([0-9.]+)','(\w+)'/.exec $(ele).attr('onclick')
          ret.push
            ip: match[1]
            checksum: match[2]
        callback null, ret

exports.logout = logout = (username, password, ip, checksum, callback) ->
  form =
    action: 'login'
    user_login_name: username
    user_password: md5(password).toString()
  request.post
    url: 'http://usereg.tsinghua.edu.cn/do.php'
    form: form
    (error, response, body) ->
      callback(error) if error
      callback(response) if response.statusCode != 200 or response.statusMessage != 'OK'
      form =
        action: 'drop'
        user_ip: ip
        checksum: checksum
      request.post
        url: 'http://usereg.tsinghua.edu.cn/online_user_ipv4.php'
        form: form
        (error, response, body) ->
          callback(error) if error
          callback(response) if response.statusCode != 200 or response.statusMessage != 'OK'
          callback null
