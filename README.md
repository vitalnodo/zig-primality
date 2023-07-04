# zig-primality
Checking whether a number is probably prime and generating a probably 
prime number. Now implemented:
* Miller-Rabin test
* Fermat test

TODO:

* investigate why it works so slowly, probably problems inside the random number generation, modular exponentiation and whatsoever
* make more reliable from the theory, add comments

Links to go deeper:
* [zig-ff](https://github.com/jedisct1/zig-ff/tree/master)
* [Montgomery Reduction with Even Modulus](http://www.people.vcu.edu/~jwang3/CMSC691/j34monex.pdf)
* [Integer factorization calculator](https://www.alpertron.com.ar/ECM.HTM)
* [Extending Stein's GCD algorithm](https://studenttheses.uu.nl/bitstream/handle/20.500.12932/33194/Thesis.pdf)
* [Montgomery Multiplication](https://web.archive.org/web/20181127065455/http://www.hackersdelight.org/MontgomeryMultiplication.pdf)
* [Montgomery reduction algorithm with Python](https://asecuritysite.com/rsa/go_mont2)
