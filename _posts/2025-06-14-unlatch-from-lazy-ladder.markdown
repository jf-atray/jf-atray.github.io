---
layout: post
title:  "Unlatch from Lazy Ladder"
date:   2025-06-14 15:38:00 -0500
categories: plc
---

1. Rough write
1. Organize loose thoughts
1. Document claims
1. Include AB reference images
1. Edit

# 1. The intro
When state bites back - Latching and unlatching encourages "bool = true" behavior where programmers are littering state left and right with no regard for maintenance. A perfectly orchestrated ladder will involve one output. You should be able to follow write-references backwards and chart any variable. 


# 2. The problem
The problem with state is it relies on you expecting the pile of variables to be in one exact shape when your code executes. This is very unhardened behavior. All it takes is for something you 'didn't expect' to result in unexpected behavior. If you're in the industries I'm in, 'unexpected behavior' is unacceptable. Additionally, latching is often done in-line which can express a lack of confidence in the sequencing of the variables. You may be one cycle off from catastrophic race-condition and not even know it.


# 3. Recognizing smell
There are a few kinds of anti-patterns that should send shivers.
* How did this bit get turned on?
* Forgetting to reset some variable on module reset
* Variable bloat
  * Having tons of bools in a big chain that latch each other one to represent a stage of work and don't really represent anything themselves



# 4. Solutions abstract
It can be acceptable to SET/RESET multiple times... if they're in differently branches of the system. Only one SET/RESET should be accessible to the code at the time. I get it, in an ideal world we should have one OTE at the top that completely describes top-to-bottom behavior but let's cut ourselves a little slack. Your output-valve may have two different state machines for homing versus steady-state behavior, but you should NEVER be relying on code in separate realms of the codebase to coincidentally knock your variables into the right shape.


# 5. Solutions handy
* If you think you need a plex of bools for a shifting condition, are you sure you don't just need an INT instead?
  * "Oh but what happens if that INT somehow ends up at a variable I don't expect?"
  * Well now your downstream functions implicitly won't consume the invalid value, unlike a series of bools which are used to produce invalid products
* Split results from conditions.

# 6. A whole thing
Consider a simple state machine that moves a set of parts in order. Todo put some of boss's work here as example.

    [ STEP >= 10 ] [ STEP < 40        ]  ->  ( Grabber_Arm )
    [ STEP >= 30 ] [ STEP < 50        ]  ->  ( Gripper_Vlv )

    [ STEP ==  0 ]                       ->  ( MOV  1 Step )
    [ STEP ==  1 ] [ Grabber_Homed    ]  ->  ( MOV 10 Step )
    [ STEP == 10 ] [ Grabber_Extended ]  ->  ( MOV 20 Step )
    [ STEP == 20 ] [ Part_Present     ]  ->  ( MOV 30 Step )
    [ STEP == 30 ] [ Gripper_OK       ]  ->  ( MOV 40 Step )
    [ STEP == 40 ] [ Grabber_Homed    ]  ->  ( MOV 50 Step )
    [ STEP == 50 ] [ Gripper_Released ]  ->  ( MOV  0 Step )