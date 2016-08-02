Db = require 'db'
Http = require 'http'
Timer = require 'timer'

leagues =
	eredivisie: 433
	epl: 426
	laliga: 436
	bl: 430
	serieA: 438
	ligue1: 434

API_TOKEN = 'cbe3ab2ba1bd47a58d60d0b2fa19f9d8' # set as header: "X-Auth-Token"

# melkmannen url: https://apps.happening.im/7622679
# origin url: https://apps.happening.im/7622676
exports.onHttp = (request) !->
	log '--received incoming http request'
	request.respond 200, API_TOKEN

exports.onInstall = exports.onUpgrade = exports.client_updateData = exports.updateLeagueData = !->
	log 'updating leagues'

	# temp, get rid of leagues in root, move to sub 'leagues'
	for l in leagues
		Db.shared.set l.key, null

	for name, id of leagues
		Http.get
			headers: {'X-Auth-Token': 'cbe3ab2ba1bd47a58d60d0b2fa19f9d8'}
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
			standing[teamCount] = team
			teamCount++
		league.standing = standing
		league.teamCount = teamCount

		Db.shared.set 'leagues', leagueName, league
	else
		log 'Error code: ' + data.status
		log 'Error msg: ' + data.error
