Db = require 'db'
Http = require 'http'
Timer = require 'timer'

leagues =
	eredivisie: 404
	epl: 398
	laliga: 399
	bl: 394
	serieA: 401
	ligue1: 396

exports.onInstall =!->
	exports.updateLeagueData()

exports.onUpgrade =!->
	exports.updateLeagueData()

exports.updateLeagueData = ->
	log 'updating leagues'
	for name, id of leagues
		Http.get
			url: "http://api.football-data.org/v1/soccerseasons/#{id}/leagueTable"
			cb: ['leagueResponse', name]
	# update again in an hour
	Timer.cancel 'updateLeagueData'
	Timer.set (60*60*1000), 'updateLeagueData'

exports.leagueResponse = (leagueName, data) !->
	if data.status == '200 OK'
		league = JSON.parse data.body

		# convert standing from array to hash
		standing = {}
		teamCount = 0
		for team in league.standing
			standing[team.position] = team
			teamCount++
		league.standing = standing
		league.teamCount = teamCount

		Db.shared.set leagueName, league
	else
		log 'Error code: ' + data.status
		log 'Error msg: ' + data.error
