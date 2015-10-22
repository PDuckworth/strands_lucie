#!/bin/bash

SESSION=$USER
DATABASE=/home/lucie01/mongodb_store/cs_level_9/
MAP=/home/lucie01/robot_files/level_9_map.yaml
WAYPOINTS=open_day_waypoints

tmux -2 new-session -d -s $SESSION
# Setup a window for tailing log files
tmux new-window -t $SESSION:0 -n 'roscore'
tmux new-window -t $SESSION:1 -n 'mongo'
tmux new-window -t $SESSION:2 -n 'robot_bringup'
tmux new-window -t $SESSION:3 -n 'cameras'
tmux new-window -t $SESSION:4 -n 'strands_ui'
tmux new-window -t $SESSION:5 -n 'strands_navigation'
tmux new-window -t $SESSION:6 -n 'RViz'
tmux new-window -t $SESSION:7 -n 'people'
tmux new-window -t $SESSION:8 -n 'openday routine'

tmux select-window -t $SESSION:0
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "roscore" C-m
tmux resize-pane -U 30
tmux select-pane -t 1
tmux send-keys "htop" C-m

tmux select-window -t $SESSION:1
tmux split-window -v
tmux select-pane -t 0
tmux send-keys "roslaunch mongodb_store mongodb_store.launch db_path:=$DATABASE port:=62345"
tmux resize-pane -D 30
tmux select-pane -t 1
tmux send-keys "robomongo"
tmux select-pane -t 0

tmux select-window -t $SESSION:2
tmux send-keys "roslaunch strands_bringup strands_robot.launch machine:=localhost user:=lucie01 with_mux:=False js:=/dev/input/js1 laser:=/dev/ttyUSB0 scitos_config:=/opt/ros/indigo/share/scitos_mira/resources/SCITOSDriver.xml"

tmux select-window -t $SESSION:3
tmux send-keys "roslaunch strands_bringup strands_cameras.launch machine:=localhost user:=lucie01 head_camera:=True head_ip:=localhost head_user:=lucie01 chest_camera:=False chest_ip:=localhost chest_user:=lucie01"

tmux select-window -t $SESSION:4
tmux send-keys "roslaunch strands_bringup strands_ui.launch"


tmux select-window -t $SESSION:5
tmux send-keys "roslaunch strands_bringup strands_navigation.launch with_camera:=True camera:=head_xtion map:=$MAP with_no_go_map:=False no_go_map:=/home/lucie01/robot_files/no_go_map.yaml with_mux:=False topological_map:=$WAYPOINTS"

tmux select-window -t $SESSION:6
tmux send-keys "rosrun rviz rviz"

tmux select-window -t $SESSION:7
tmux split-window -v
tmux select-pane -t 0
tmux send-keys "roslaunch perception_people_launch people_tracker_robot.launch log:=true"
tmux select-pane -t 1
tmux send-keys "roslaunch human_trajectory human_trajectory.launch"
tmux select-pane -t 0

tmux select-window -t $SESSION:8
tmux split-window -v
tmux select-pane -t 0
tmux send-keys "roslaunch task_executor task-scheduler-top.launch"
tmux select-pane -t 1
tmux send-keys "rosrun routine_behaviours patroller_routine_node.py"
tmux select-pane -t 0


# Set default window
tmux select-window -t $SESSION:0

# Attach to session
tmux -2 attach-session -t $SESSION

tmux setw -g mode-mouse on
