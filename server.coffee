Db = require 'db'
Http = require 'http'

exports.client_fetch = ->
	Http.get
		url: 'http://api.football-data.org/v1/soccerseasons/404/leagueTable'
		cb: 'leagueResponse' # corresponds to exports.hnResponse below

exports.leagueResponse = (data) !->
	if data.status == '200 OK'
		eredivisie = JSON.parse data.body
		standing = {}
		for team in eredivisie.standing
			standing[team.position] = team

		eredivisie.standing = standing

		Db.shared.set 'eredivisie', eredivisie
	else
		log 'Error code: ' + data.status
		log 'Error msg: ' + data.error
