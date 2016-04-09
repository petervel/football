Db = require 'db'
Http = require 'http'

leagues =
	eredivisie: 404
	epl: 398
	laliga: 399
###
	bl: 394
	serieA: 401
	ligue1: 396
###
exports.client_fetch = ->
	for name, id of leagues
		Http.get
			url: "http://api.football-data.org/v1/soccerseasons/#{id}/leagueTable"
			cb: ['leagueResponse', name]

exports.leagueResponse = (leagueName, data) !->
	if data.status == '200 OK'
		league = JSON.parse data.body

		# convert standing from array to hash
		standing = {}
		for team in league.standing
			standing[team.position] = team
		league.standing = standing

		Db.shared.set leagueName, league
	else
		log 'Error code: ' + data.status
		log 'Error msg: ' + data.error
