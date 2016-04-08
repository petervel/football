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
	Ui.button "Fetch Eredivisie", !-> Server.send 'update'

	Obs.observe !->
		eredivisie = JSON.parse Db.shared.get('eredivisie')

		Dom.h2 eredivisie.leagueTitle

		for team in eredivisie.standing
			Ui.item !->
				Dom.div !->
					Dom.style Flex: 1
					Dom.text team.teamName
				Dom.div !->
					Dom.text team.points