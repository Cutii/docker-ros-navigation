# docker-ros-navigation

This dockerfile allow you to build an image based on [melodic-ros-core-stretch](https://github.com/osrf/docker_images/blob/1a1c56d93f309d10c412c6323db5791fc1b23d1b/ros/melodic/debian/stretch/ros-core/Dockerfile) image.

If you are building a robot that use :
- An intel RealSense depth camera
- Google cartographer ros package 
Maybe you will find this image usefull.
As we are using some [rust](https://www.rust-lang.org/) related things and we have to bind them to ROS (cpp), this image also contain : 
- Rust/cargo install
- [Cbindgen install](https://github.com/eqrion/cbindgen) 

NB : :warning: /!\ Not production ready /!\ 