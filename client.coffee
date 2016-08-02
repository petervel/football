Comments = require 'comments'
Db = require 'db'
Dom = require 'dom'
Modal = require 'modal'
Obs = require 'obs'
App = require 'app'
Page = require 'page'
Server = require 'server'
Ui = require 'ui'

leagueIds = ['eredivisie', 'epl', 'laliga', 'bl', 'serieA', 'ligue1']

exports.render = ->
	selectedLeague = Obs.create('eredivisie')

	Dom.div !->
		Dom.style
			Box: 'horizontal'
			justifyContent: 'center'
			margin: '16px 0'
		Dom.select !->
			me = Dom.get()
			Dom.on 'change', !-> selectedLeague.set me.value()
			Dom.on 'blur', !-> selectedLeague.set me.value()

			for leagueId in leagueIds then do (leagueId) !->
				league = Db.shared.ref 'leagues', leagueId
				Dom.option !->
					Dom.prop 'value', league.key()
					Dom.text league.get 'leagueCaption'

					if league.key() is selectedLeague.peek()
						Dom.prop 'checked', 'checked'

	Obs.observe !->
		Db.shared.iterate 'leagues', selectedLeague.get(), 'standing', showTeam, (team) -> team.get 'position'

	if App.userIsAdmin()
		Ui.button "Update", !-> Server.send 'updateData'

showTeam = (team) !->
	collapsed = Obs.create true
	Obs.observe !->
		Ui.item !->
			Dom.onTap !-> collapsed.set not collapsed.peek()
			Dom.style
				Box: 'vertical'
				justifyContent: 'center'

			Dom.div !->
				Dom.style Box: 'horizontal', alignItems: 'center'
				Dom.div !->
					Dom.style minWidth: '20px', textAlign: 'right'
					Dom.text team.get 'position'
				Dom.img !->
					Dom.style width: '24px', height: '24px', margin: '0 10px'
					Dom.prop 'src', team.get 'crestURI'
				Dom.div !->
					Dom.style Flex: 1
					Dom.text team.get 'teamName'

				Dom.div !->
					Dom.span !->
						Dom.style color: 'grey'
						Dom.text team.get 'playedGames'
						Dom.text " – "
					Dom.span !->
						Dom.style fontWeight: 'bold', width: '30px', textAlign: 'right', marginRight: '10px'
						Dom.text team.get 'points'

			return if collapsed.get()

			Dom.div !->
				Dom.style Box: 'horizontal', justifyContent: 'center'

				Dom.div !->
					Dom.style width: '120px'
					Dom.span !->
						Dom.style fontWeight: 'bold'
						Dom.text "P: #{team.get 'playedGames'} "
					Dom.span !->
						Dom.style color: 'grey'
						Dom.text "(#{team.get 'wins'}-#{team.get 'draws'}-#{team.get 'losses'})"

				Dom.div !->
					Dom.style width: '30px'

				Dom.div !->
					Dom.style width: '120px'
					Dom.span !->
						Dom.style fontWeight: 'bold'
						Dom.text "GD: #{team.get 'goalDifference'} "
					Dom.span !->
						Dom.style color: 'grey'
						Dom.text "(#{team.get 'goals'}-#{team.get 'goalsAgainst'})"

