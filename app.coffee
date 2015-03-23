request = require('request').defaults
  jar: true
md5 = require 'crypto-js/md5'
cheerio = require 'cheerio'

login = (username, password, callback) ->
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

account = (username, password, callback) ->
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
      request.get
        url: 'http://usereg.tsinghua.edu.cn/online_user_ipv4.php'
        (error, response, body) ->
          callback(error) if error
          callback(response) if response.statusCode != 200
          $ = cheerio.load body
          $('.maintd input').each (_, ele) ->
            console.log $(ele).attr('onclick')

a = require './secret.json'
account a.username, a.password, (error, usage) ->
  throw error if error
  console.log usage
