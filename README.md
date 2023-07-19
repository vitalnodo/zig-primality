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
* [AndersonZM/Primality-Testing](https://github.com/AndersonZM/Primality-Testing/)
* [How hard can generating 1024-bit primes really be?](https://glitchcomet.com/articles/1024-bit-primes/)
* [Osmanbey Uzunkol ATKIN’S ECPP (Elliptic Curve Primality Proving) ALGORITHM](http://www.staff.uni-oldenburg.de/osmanbey.uzunkol/publications/master.pdf)
* [Jake Massimo An Analysis of Primality Testing and Its Use in Cryptographic Applications](https://pure.royalholloway.ac.uk/ws/portalfiles/portal/39023193/2020MassimoJPhD.pdf)
* [Safe Prime Database and API](https://2ton.com.au/safeprimes/)
* [Michael J. Wiener Safe Prime Generation with a Combined Sieve](https://eprint.iacr.org/2003/186.pdf)
* [Decisional Diffie–Hellman assumption](https://en.wikipedia.org/wiki/Decisional_Diffie–Hellman_assumption)