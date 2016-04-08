Db = require 'db'

exports.client_fetch = ->
	Http = require 'http'
	Http.get
		url: 'http://api.football-data.org/alpha/soccerseasons/404/leagueTable'
		cb: 'edResponse' # corresponds to exports.hnResponse below

exports.edResponse = (data) !->
	if data.status == '200 OK'
		Db.shared.set 'eredivisie', data.body
	else
		log 'Error code: ' + data.status
		log 'Error msg: ' + data.error