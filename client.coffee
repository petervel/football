Comments = require 'comments'
Db = require 'db'
Dom = require 'dom'
Modal = require 'modal'
Obs = require 'obs'
App = require 'app'
Page = require 'page'
Server = require 'server'
Ui = require 'ui'

leagueIds = ['eredivisie', 'epl', 'laliga']

exports.render = ->
	selectedLeague = Obs.create('eredivisie')

	Dom.div !->
		Dom.style
			Box: 'horizontal'
			justifyContent: 'center'
		for leagueId in leagueIds then do (leagueId) !->
			Ui.button Db.shared.get(leagueId, 'leagueCaption'), !-> selectedLeague.set leagueId

	Obs.observe !->
		for i in [1..18]
			showTeam Db.shared.get selectedLeague.get(), 'standing', i

	if App.userIsAdmin()
		Ui.button "Update", !-> Server.send 'fetch'

showTeam = (team) !->
	collapsed = Obs.create true
	Obs.observe !->
		Ui.item !->
			Dom.onTap !-> collapsed.set not collapsed.peek()
			Dom.style
				Box: 'vertical'
				justifyContent: 'center'

			Dom.div !->
				Dom.style
					Box: 'horizontal'
					alignItems: 'center'
				Dom.div !->
					Dom.style
						minWidth: '20px'
						textAlign: 'right'
					Dom.text team['position']
				Dom.img !->
					Dom.style
						width: '24px'
						height: '24px'
						margin: '0 10px'
					Dom.prop 'src', team['crestURI']
				Dom.div !->
					Dom.style Flex: 1
					Dom.text team['teamName']

				Dom.div !->
					Dom.style
						fontWeight: 'bold'
						width: '30px'
						textAlign: 'right'
						marginRight: '10px'
					Dom.text team['points']

			return if collapsed.get()

			Dom.div !->
				Dom.style
					Box: 'horizontal'
					justifyContent: 'center'

				Dom.div !->
					Dom.style width: '120px'
					Dom.span !->
						Dom.style fontWeight: 'bold'
						Dom.text "P: #{team['playedGames']} "
					Dom.span !->
						Dom.style color: 'grey'
						Dom.text "(#{team['wins']}-#{team['draws']}-#{team['losses']})"

				Dom.div !->
					Dom.style width: '30px'

				Dom.div !->
					Dom.style width: '120px'
					Dom.span !->
						Dom.style fontWeight: 'bold'
						Dom.text "GD: #{team['goalDifference']} "
					Dom.span !->
						Dom.style color: 'grey'
						Dom.text "(#{team['goals']}-#{team['goalsAgainst']})"

