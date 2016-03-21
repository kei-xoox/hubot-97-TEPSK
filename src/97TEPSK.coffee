# Description
#   Displays a random message from
#   https://ja.m.wikisource.org/wiki/プログラマが知るべき97のこと
#
# Dependencies:
#   cheerio-httpcli, google-url
#
# Configuration:
#   HUBOT_GOOGLE_CSE_KEY
#
# Commands:
#   hubot 97 -  Displays a random message from https://ja.m.wikisource.org/wiki/プログラマが知るべき97のこと
#
# Author:
#  k-ysd <kysd24@gmail.com>

client = require 'cheerio-httpcli'
googleUrl = require "google-url"
urlBasic = 'https://ja.m.wikisource.org/wiki/' +
  '%E3%83%97%E3%83%AD%E3%82%B0%E3%83%A9%E3%83%9E%E3%81%8C%E7%9F%A5%E3%82%8B%E3'+
  '%81%B9%E3%81%8D97%E3%81%AE%E3%81%93%E3%81%A8'
googleUrl = new googleUrl({key: process.env.HUBOT_GOOGLE_CSE_KEY})

getMessage = (msg) ->
  client.fetch urlBasic, {q:'node.js'}, (err, $, res) ->
    li = $("#mw-content-text > div > ol:nth-child(3) > li:nth-child(1)")
    i = Math.random() * 97 | 0

    unless li?
      return

    if i != 0
      for j in [0..i]
        li = li.next()

    # deadlink
    if li.contents().attr('href').indexOf("redlink") is -1
      li = li.next()

    url = "http://ja.m.wikisource.org" +
      li.contents().attr('href')
    title = li.contents().attr('title')

    if process.env.HUBOT_GOOGLE_CSE_KEY?
      googleUrl.shorten url, (err, shortUrl) ->
        msg.reply title + "\n" + shortUrl
    else
      msg.reply title + "\n" + url

module.exports = (robot) ->
  robot.respond /97/, (msg) ->
    getMessage(msg)
