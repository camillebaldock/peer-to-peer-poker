# Peer to Peer: Camille Baldock, Tom Stuart, Drew Neil 

## Problem description

A “hand” in poker consists of five playing cards drawn from a standard deck. Implement a system which can decide which of two hands has the highest ranking, according to the standard poker ranking rules.

## Video

TBA

## After the video

1) Finish implementing all the poker hands
in a "shameless green" style

2) Address the ```##DUPE! pip_count``` comment
the ```pip_count``` and ```suit_count``` methods are essentially duplicates of each other

3) Address the ```##bob``` comment
##bob is a slightly silly notation I use when I have a method/class/variable with a name that does not please me (not descriptive enough, actually wrong, any possibility for confusion) but I can't think of a better name at time of writing
In this case ```pip_count``` and ```suit_count``` don't describe the intention of those methods

4) Address the ```#TODO: live in a helper, utility``` comment
The consecutive_cards? methods is mainly checking whether an array is made of consecutive integers. The logic for this is now moved to the ArrayHelper. 

5) Address the ```#TODO: fail nicely when not 5 cards``` comment
The HandParser now gets initialized with an array of card strings and fails if the array is the wrong size.

6) Address the ```#TODO: this is not a nice interface``` comment

7) Open closed principle: move logic to CardParser
New card parser and add pending tests:
#TODO: fail loudly and with better errors with unexpected inputs
