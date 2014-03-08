LiteCoin_Control
================
The directory contains some scripts that ensures minerd(a LiteCoin miner) run on machines without active VMs by 
1). Adding a few lines of code in openstack-nova's filter_scheduler. Get the machines which are scheduled to run requested VMs and kill minerd on these machines.
2). Using crond service to periodically run a script that could get machines without running VMs and start running minerd on these machines.
