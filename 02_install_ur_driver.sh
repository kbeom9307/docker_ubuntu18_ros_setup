
cd ~/catkin_ws

git clone https://github.com/UniversalRobots/Universal_Robots_ROS_Driver.git src/Universal_Robots_ROS_Driver
git clone -b melodic-devel https://github.com/ros-industrial/universal_robot.git src/universal_robot

sudo apt-get install ros-melodic-ros-control ros-melodic-ros-controllers 
sudo apt-get install ros-melodic-gazebo-ros-control

sudo apt update -qq
rosdep update --include-eol-distros
rosdep install --from-paths src --ignore-src -y

catkin_make

source ~/.bashrc

# after setup test with rb or ur
