Building the Resin Globe
========================

* Each Pi
  * Each PI is quite simple, a set of flat-top LEDs and current limiting resisters
* Power Distribution
  * Choose a power supply with a cylindrical power socket
* Fitting
  * Sugru, dremmel and zip ties!
* Coding
  * For full details see index.coffee
  * It connects a session to a Flowdock instance
  * As events come in it translates them to glowing pins and timeouts a dull
* Deploying
  * resin.io of course!
    * don't have to keep breaking the globe apart
    * can push once and the whole fleet updates
* Configuring
  * To find each pin there is the FIND_PIN environment variable
  * You'll need credentials and an object of who is where
