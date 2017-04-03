flowdock = require('flowdock')
pins = require('pi-pins')

class ResinGlobe
	constructor: (token, user_pins, duration) ->
		@pinIdToPin = {}
		@pinIdToTimeout = {}
		userIdToPinId = {}
		userIdToUserName = {}
		session = new flowdock.Session(token)
		for pin_id in [0...27]
			@pinIdToPin[pin_id] = pins.connect(pin_id)
			@pinIdToPin[pin_id].mode('out')
			@pinIdToPin[pin_id].value(false)
		session.flows (err, flows, res) =>
			for flow in flows
				for user in flow.users
					pin_id = user_pins[user.nick]
					userIdToUserName[user.id] = user.nick
					userIdToPinId[user.id] = pin_id
			ids = (flow.id for flow in flows)
			stream = session.stream(ids, active: 'idle')
			stream.on 'message', (message) =>
				@glow(userIdToPinId[message.user], duration, userIdToUserName[message.user])
			console.log('Connected.')
			for pin_id, pin of @pinIdToPin
				@glow(pin_id, 2000)

	glow: (pin_id, duration, message) =>
		if(pin_id? and @pinIdToPin[pin_id]?)
			message ?= "Pin #{pin_id} will be lit for #{duration}ms"
			console.log(message)
			@pinIdToPin[pin_id].value(true)
			clearTimeout(@pinIdToTimeout[pin_id])
			@pinIdToTimeout[pin_id] = setTimeout(@createDuller(pin_id), duration)

	createDuller: (pin_id, message) =>
		pin = @pinIdToPin[pin_id]
		return ->
			if(pin?)
				message ?= "Pin #{pin_id} is turning off"
				console.log(message)
				pin.value(false)

findPin = process.env.FIND_PIN
if(findPin?)
	pinIdToPin = {}
	for pin_id in [0...27]
		pinIdToPin[pin_id] = pins.connect(pin_id)
		pinIdToPin[pin_id].mode('out')
	while(true)
		lit = Math.round((new Date().getTime()) / 1000) % 3
		for pin_id in [0...27]
			pinIdToPin[pin_id].value(lit and (findPin == '*' or parseInt(findPin) == pin_id))
else
	new ResinGlobe(process.env.FLOWDOCK_API_TOKEN, JSON.parse(process.env.USERS), parseInt(process.env.DURATION ? '1') * 1000)
