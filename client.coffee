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

	#Dom.h2 eredivisie.leagueTitle
	Ui.item !->
		for desc in '# team g p w d l gf g gd'.split(' ')
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
			for attr in 'position teamName playedGames points wins draws losses goals goalsAgainst goalDifference'.split(' ')
				Dom.div !->
					if attr is 'teamName'
						Dom.style Flex: 1
						Dom.text " " + team[attr]
					else
						Dom.style
							width: '25pt'
							textAlign: 'center'
							margin: 0

						Dom.span !->
							if attr is 'teamName'
								Dom.style fontWeight: 'bold'

							Dom.text " " + team[attr]
						Dom.text "  |"