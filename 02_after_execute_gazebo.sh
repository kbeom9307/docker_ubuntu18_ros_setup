# for fix gazebo error
echo "---" > ~/.ignition/fuel/config.yaml
echo "# The list of servers." >> ~/.ignition/fuel/config.yaml
echo "servers:" >> ~/.ignition/fuel/config.yaml
echo "  -" >> ~/.ignition/fuel/config.yaml
echo "    name: osrf" >> ~/.ignition/fuel/config.yaml
echo "    url: https://api.ignitionrobotics.org" >> ~/.ignition/fuel/config.yaml
