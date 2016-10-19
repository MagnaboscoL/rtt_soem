require "rttlib"
require "rttros"

taskContext = rtt.getTC()
dp = taskContext:getPeer("Deployer")

-- ROS integration
-- delpoyer:import("rtt_rosnode")
-- delpoyer:import("rtt_roscomm")

-- import components, requires correctly setup RTT_COMPONENT_PATH
dp:import("ocl")

-- import components, requires correctly setup ROS_PACKAGE_PATH (>=Orocos 2.7)
dp:import("rtt_ros")

-- EtherCAT Master stuff
-- dp:path ("/home/luca/ROS/catkin_wstool_ws/src")
dp:import("soem_master");
dp:import("soem_ebox");
dp:import("soem_lenze8400topline");
dp:loadComponent("ethercatMaster", "soem_master::SoemMasterComponent")
master = dp:getPeer("ethercatMaster")

master:loadService('marshalling')

if (false == master:provides('marshalling'):loadProperties("soem.cpf")) then
    rtt.logl("Error","Failed to connect plant and io components")
end

dp:setActivity("ethercatMaster", 0.001, 10, rtt.globals.ORO_SCHED_RT); 

master:configure()

master:start()
