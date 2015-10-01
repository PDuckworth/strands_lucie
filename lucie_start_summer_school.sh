#!/bin/bash

SESSION=$USER

tmux -2 new-session -d -s $SESSION
# Setup a window for tailing log files
tmux new-window -t $SESSION:0 -n 'roscore'
tmux new-window -t $SESSION:1 -n 'mongo'
tmux new-window -t $SESSION:2 -n 'strands_robot'
tmux new-window -t $SESSION:3 -n 'strands_cameras'
tmux new-window -t $SESSION:4 -n 'strands_ui'
tmux new-window -t $SESSION:5 -n 'strands_navigation'
tmux new-window -t $SESSION:6 -n 'RViz'
tmux new-window -t $SESSION:7 -n 'people_perception'
tmux new-window -t $SESSION:8 -n 'trajectory_pub'
tmux new-window -t $SESSION:9 -n 'soma'
tmux new-window -t $SESSION:10 -n 'qsrLib'
tmux new-window -t $SESSION:11 -n 'episodes'


tmux select-window -t $SESSION:0
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "roscore" C-m
tmux resize-pane -U 30
tmux select-pane -t 1
tmux send-keys "htop" C-m

tmux select-window -t $SESSION:1
tmux send-keys "roslaunch mongodb_store mongodb_store.launch db_path:=/opt/strands/mongodb_store port:=62345"

tmux select-window -t $SESSION:2
tmux send-keys "roslaunch strands_bringup strands_robot.launch machine:=localhost user:=lucie01 with_mux:=False js:=/dev/input/js0 laser:=/dev/ttyUSB0 scitos_config:=/opt/ros/indigo/share/scitos_mira/resources/SCITOSDriver.xml"

tmux select-window -t $SESSION:3
tmux send-keys "roslaunch strands_bringup strands_cameras.launch machine:=localhost user:=lucie01 head_camera:=True head_ip:=localhost head_user:=lucie01 chest_camera:=False chest_ip:=localhost chest_user:=lucie01"

tmux select-window -t $SESSION:4
tmux send-keys "roslaunch strands_bringup strands_ui.launch"

tmux select-window -t $SESSION:5
tmux send-keys "roslaunch strands_bringup strands_navigation.launch with_camera:=True camera:=head_xtion map:=/home/lucie01/robot_files/cs_lab_final.yaml with_no_go_map:=False no_go_map:=/home/lucie01/robot_files/no_go_map.yaml with_mux:=False topological_map:=test_points"

tmux select-window -t $SESSION:6
tmux send-keys "rosrun rviz rviz"

tmux select-window -t $SESSION:7
tmux send-keys "roslaunch perception_people_launch people_tracker_robot.launch log:=true"

tmux select-window -t $SESSION:8
tmux send-keys "roslaunch human_trajectory human_trajectory.launch"

tmux select-window -t $SESSION:9
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "rosrun soma_manager soma.py cs_lab_final test_config"
tmux select-pane -t 1
tmux send-keys "rosrun soma_roi_manager soma_roi.py cs_lab_final test_config"

tmux select-window -t $SESSION:10
tmux split-window -h
tmux select-pane -t 0
tmux send-keys "rosrun qsr_lib qsrlib_ros_server.py"
tmux select-pane -t 1
tmux send-keys "rosrun qsr_lib rviz_qsrlib_server.py"

tmux select-window -t $SESSION:11
tmux send-keys "roslaunch relational_learner episodes.launch vis:=1" 

# Set default window
tmux select-window -t $SESSION:0

# Attach to session
tmux -2 attach-session -t $SESSION

tmux setw -g mode-mouse on
