# AI

Attempt to simulate neural activity for vision.

## TODO

* Decide on max charge for graded and bizarro cells.
* Create cell network creator that takes a simple config file.  yaml?

### Creator

shape:
level 1
C1 C2 C3
C4 C5 C6
C7 C8 C9

level 2
H1 H2 B

level 3
G

connections:
C1 -> H1
C2 -> H1
C3 -> H1
C4 -> H1
C6 -> H1
C7 -> H1
C8 -> H1
C9 -> H1

C5 -> H2

H1 -> C5

H2 -> C1
H2 -> C2
H2 -> C3
H2 -> C4
H2 -> C6
H2 -> C7
H2 -> C8
H2 -> C9

C5 -> B

B -> G
