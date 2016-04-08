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
	if App.userIsAdmin()
		Ui.button "Update", !-> Server.send 'fetch'

	for i in [1..18]
		showTeam Db.shared.get 'eredivisie', 'standing', i

showTeam = (team) !->
	collapsed = Obs.create true
	Obs.observe !->
		if collapsed.get()
			Ui.item !->
				Dom.onTap !-> collapsed.set false

				Dom.div !->
					Dom.style
						Flex: 1
						Box: 'horizontal'
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
						marginRight: '10px'
					Dom.text team['points']
		else
			# TODO: organize and stylise, looks like shit atm.
			Dom.div !->
				Dom.onTap !-> collapsed.set true
				attrs = 'position teamName playedGames points wins draws losses goals goalsAgainst goalDifference'.split(' ')
				titles = '# team g p w d l gf g gd'.split(' ')
				for i in [0...attrs.length]
					Dom.div !->
						Dom.text titles[i] + ": " + team[attrs[i]]


		###
			for desc in '# team g p w d l gf g gd'.split(' ')
			Dom.div !->
				if attr is 'teamName'
					Dom.style Flex: 1
					Dom.text team[attr]
				else
					Dom.text team[attr]
		###