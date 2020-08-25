-------------------------------------------------------------------------------
-- 
--  Simple GPWS Altitude Callouts
--
--  FlyWithLua script for X-Plane 11 by Ari Laukkanen
--
--  Version 1.0 Aug-25-2020
--
-------------------------------------------------------------------------------

-- Settings below, please read comments.

-------------------------------------------------------------------------------
-- Aircrafts where this script is enabled

-- Adding aircraft: Add ICAO code of aircraft to ENABLE_GPWS_ICAO definition below.
-- "ALL" enables GPWS for all aircraft.
-- ICAO references: https://www.icao.int/publications/DOC8643/Pages/Search.aspx
-- ICAO wikipedia: https://en.wikipedia.org/wiki/List_of_aircraft_type_designators
-- Example:  local ENABLE_GPWS_ICAO = "B190, C172, BE58"
-- Example2: local ENABLE_GPWS_ICAO = "ALL"

local ENABLE_GPWS_ICAO = "C172"


-------------------------------------------------------------------------------
-- Default GPWS altitude callouts (ft above ground level)

-- These are used when no custom alerts are defined (see below).
-- Alert sounds are loaded from default X-Plane sound resources (Resources/sounds/alert/).
-- NOTE: Matching wav file (e.g. 2500ft.wav) must be present in sound resources!

local DEFAULT_GPWS_ALTITUDE_CALLOUTS = {1000, 500, 400, 300, 200, 100, 50, 40, 30, 20, 10}


-------------------------------------------------------------------------------
-- Custom GPWS altitude callouts (ft above ground level)

-- These override default GPWS alerts for given aircraft.
-- Wav files must be found from resources, see defaults above.
-- For example Carenado B1900D has 500ft alert by default, so no need to play that.
-- C172 alerts given as an example, and should be modified as needed if used.

local CUSTOM_GPWS_ALTITUDE_CALLOUTS = {}

CUSTOM_GPWS_ALTITUDE_CALLOUTS["B190"] = {1000, 400, 300, 200, 100, 50, 40, 30, 20, 10}
--CUSTOM_GPWS_ALTITUDE_CALLOUTS["C172"] = {500, 400, 300, 200, 100, 50, 40, 30, 20, 10}

-------------------------------------------------------------------------------
-- GPWS volume control

-- Use decimal value between 0 and 1, e.g. 0.2, 0.55, or 1.

local GAIN = 0.3


-------------------------------------------------------------------------------
-- DO NOT EDIT BELOW THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING!
-------------------------------------------------------------------------------

if string.find(ENABLE_GPWS_ICAO, PLANE_ICAO) or string.find(ENABLE_GPWS_ICAO, "ALL") then

	dataref( "ALT", "sim/flightmodel/position/y_agl")
	dataref( "VERTICAL_VELOCITY", "sim/flightmodel/position/vh_ind")
	dataref( "REPLAY_MODE", "sim/time/is_in_replay")
	
	local FT = 3.281 
	local SOUND_FILES_DIRECTORY = SYSTEM_DIRECTORY .. "Resources/sounds/alert/"
	
	local alerts_ft = DEFAULT_GPWS_ALTITUDE_CALLOUTS
	
	if CUSTOM_GPWS_ALTITUDE_CALLOUTS[PLANE_ICAO] ~= nil then
		alerts_ft = CUSTOM_GPWS_ALTITUDE_CALLOUTS[PLANE_ICAO]
	end
			
	local alert_sounds = {}
	local alert_played = {}
	
	for _, alt_ft in pairs(alerts_ft) do
		alert_sounds[alt_ft] = load_WAV_file(SOUND_FILES_DIRECTORY .. alt_ft .. "ft.wav")
		set_sound_gain(alert_sounds[alt_ft], GAIN)
		alert_played[alt_ft] = false
	end
	
	function GPWSCallout()
		if ALT < 1200 then
			if VERTICAL_VELOCITY <= 0 then 
				for _, alt_ft in pairs(alerts_ft) do
					if ALT >= (alt_ft-9)/FT and ALT <= alt_ft/FT and not alert_played[alt_ft] and REPLAY_MODE == 0 then
						play_sound(alert_sounds[alt_ft])
						alert_played[alt_ft] = true
					end
				end
			end
			for _, alt_ft in pairs(alerts_ft) do
				if alert_played[alt_ft] and ALT > (alt_ft+5)/FT then
					alert_played[alt_ft] = false
				end
			end			
		end
	end	

	do_every_frame ("GPWSCallout()")

end
