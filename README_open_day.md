# HOW TO: LUCIE Open Days

Document to start Lucie at Open Days (in the long-room of EC Stoner).


1. Turn ON
----------
Lucie should be situated on the charging station.
There is an 'On/Off' key in the little control pannel (bottom right near base).
On the mini-screen you need to select 'turn on robot and PC', (press the dial to select).


2. Ubuntu
------------
Wait for ubuntu to start

Find the keyboard (on switch is on the back of the wireless keyboard)

Account 'Lucie01'

Select WiFi network (top right corner). It's best to select Eduroam although it's not essential to be online.

If the internet doesn't work - you might need to run the command: `sudo service dnsmasq restart` in a terminal.


CHECK: Open the 'JoyStick' application (shortcut on the left). Check it displays the joystick with '..dev/input/js0'. (Remember if it's different!)


3. Terminal
------------
Open a new terminal (shortcut on the left).


Run `./Desktop/lucie_start_open_day.sh`

A Tmux terminal session will open, and a split screen with 'roscore' on the left and 'htop' on the right (both will run).


Tmux - (background reading)
------------
The start scrip has embedded multiple terminals. Along the bottom there should be a list 0 to 8 (ish), they all have a name too.


mini help sheet:


In tmux, hit the prefix `ctrl+b` then:


    `n` : goes to the next
    'p' : goes to the previous
    '4' : goes to window number 4
    'up/down/left/right arrow' moves betwen selected panes if the current window is split into multiple.


Here is a full [tmux cheatsheet](https://gist.github.com/PDuckworth/af7b4424afa6f91180f4)


Tip: There is no indication if Caps Lock is selected or not on the keyboard. Tmux commands won't work in caps. so be careful.


4. Tmux Script
----------------

Essentially, you need to scroll through each Tmux window and start them running (press enter). More details on each window is given below. (Note: Ctrl +b then n to switch to the next window).


Ignore Pane 0: roscore -- always needs to run first. (runs itself)

  htop             -- ignore (also runs itself)

1. mongodb          -- always run second.

   (split-pane): robomongo        -- not needed - ignore.


2. strands_bringup  -- need to check that the joystick says /dev/input/js1 before running. Else, change the command here.

  after executing, wait until it say "going into main loop".
  NOTE: if there are lots of warnings. Maybe Ctrl+c and re-run this. (sometimes happens if you've just turned the robot on).


3. cameras          -- run next (turns the cameras on).


4. strands UI       -- MARY server... starting (allows lucie to speak).


5. navigation       -- main script for loading robot map and waypoints. More info [here](https://github.com/strands-project/strands_navigation/tree/indigo-devel/topological_navigation)


6. rviz             -- for visualisation.


  Check RVIZ: check the map loads, the robot model is correcly positioned, laser (red dots) appear and the waypoints can be seen as green arrows. (more info below).

  If Lucie is not located on the charge station, there is a '2D Pose Estimate' button at the top which can be used to set her position in the map.

  Tip: Often topics don't load, and you can uncheck and then re-check the tick box (in the left panel) for the specific topic to be shown.


7. people           -- to detect and log to the database people detection. (Ctrl + b then 'down arrow' to switch between panes).

  (split-pane): trajectories     -- to stitch detections into people trajectories (and log them). (Ctrl+b then down arrow to select bottom pane).
.

8. schedule         -- always start before the routine below (wait a minute)

   (split-pane): routine          -- sends tasks which are to navigate to the different waypoints. (Ctrl+b then down arrow to select bottom pane).

  more info [here](https://github.com/strands-project/strands_executive/blob/hydro-release/README.md) and [here](https://github.com/strands-project/strands_executive)



5. RVIZ
----------------
This is the visualisation tool used in ROS. It visualises many different topics being published by the various scripts being ran.

The default configuration should load:

  * map

  * robot model

  * lazer scanner      

  * waypoint (go to)   -- These are clickable, and will send the robot there (technically it will be a task added into the schedule, so it might not be instant).

  * people tracker     -- to represent detected people on the map



6. Overrides
----------------
  * If Lucie is perfoming a scheduled task, you can always stop the corresponging Tmux panes: (5. or 9.)
Press Ctrl+c as many times as you can :)

  * Use the JoyStick  -- Press and hold LB and Lucie should stop. The analogue D-pad can be used to drive her around.
If the bumper is pressed, her motors will be dissengaged. Press START on the joystick to resume controlling her.

  * On the mini-screen used to turn the robot on/off, there is a drive option which allows you to access the "Free Run" - which allows you to push her very easily.
NOTE: Not exact instruction at the moment!


7. Current Issues
----------------

  * Door Pass    -- currently the routine include some waypoints in the study room. These are accessed via a "door pass" waypoint (just outside the door).

  This works if the door is open. However, if the door is closed, the scheduler does not seem to set a new task (which would involve driving away from the door to another waypoint).

  * Restarts  -- if for any reason you need to close everthing and re-start. Two things you must do two things:

   1. `tmux kill-session -t lucie01` in a new terminal, will stop the tmux session cmpletely. Just closing the terminal wont stop it (it can be re-accessed with: "tmux a -t lucie01")


   2. Mongodb (pane 1 in tmux), doesn't always close cleanly and often leaves a lock inplace preventing you running it again.
      Run `ps aux | grep mongodb` in a new terminal, it will show if it is locked, then `sudo kill process_ID_number` will stop it. No need to kill the last one in the list.


8. End of the Day
-------------------

Lucie's routine is to patroll between the hours of 8.30 and 5.30. Outside of these hours she should go to her charge station. However, if you need the day to end before that, you can stop the routine / schedule and click on the green waypoint in rviz which will send her to a specific place (charge station is recommended).

To close Tmux, Ctrl+b then d detaches from the session, and you can then do: `tmux kill-session -t lucie01` to end all the embeded terminals. (Or you can run the kill-session in another terminal without detaching.
