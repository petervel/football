Comments = require 'comments'
Db = require 'db'
Dom = require 'dom'
Modal = require 'modal'
Obs = require 'obs'
App = require 'app'
Page = require 'page'
Server = require 'server'
Ui = require 'ui'

exports.render = ->
	Ui.button "Update", !-> Server.send 'fetch'

	eredivisie = JSON.parse Db.shared.get('eredivisie')

	info = {
			'#': 'position',
			'team': 'teamName',
			'g': 'playedGames',
			'p': 'points',
			'w': 'wins',
			'd': 'draws',
			'l': 'losses',
			'gf': 'goals',
			'ga': 'goalsAgainst',
			'gd': 'goalDifference'
		}

	#Dom.h2 eredivisie.leagueTitle
	Ui.item !->
		for desc of info
			Dom.div !->
				if desc is 'team'
					Dom.style Flex: 1
					Dom.text desc
				else
					Dom.style
						width: '25pt'
						textAlign: 'center'
						margin: 0
					Dom.span !->
						if desc is 'p'
							Dom.style fontWeight: 'bold'
						Dom.text desc
					Dom.text ' |'

	for team in eredivisie.standing
		Ui.item !->
			for desc of info
				Dom.div !->
					attr = info[desc]
					if desc is 'team'
						Dom.style Flex: 1
						Dom.text " " + team[attr]
					else
						Dom.style
							width: '25pt'
							textAlign: 'center'
							margin: 0

						Dom.span !->
							if desc is 'p'
								Dom.style fontWeight: 'bold'

							Dom.text " " + team[attr]
						Dom.text "  |"