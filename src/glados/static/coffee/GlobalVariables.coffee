# use this object to store global variables, such as the current chembl id being requested in the page.
GlobalVariables = {}

# tells whether or not the command key in Mac OSX is down or not
GlobalVariables.IS_COMMAND_KEY_DOWN = false

# OPERA KEY CODE: 17
# WEBKIT (SAFARI/CHROME) KEY CODE LEFT: 91
# WEBKIT (SAFARI/CHROME) KEY CODE RIGHT: 93
# FIREFOX KEY CODE: 224
$(window).keydown (event)->
  if event.keyCode in [17, 91, 93, 224]
    GlobalVariables.IS_COMMAND_KEY_DOWN = true
$(window).keyup (event)->
  if event.keyCode in [17, 91, 93, 224]
    GlobalVariables.IS_COMMAND_KEY_DOWN = false