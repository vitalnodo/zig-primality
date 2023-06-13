const std = @import("std");
const testing = std.testing;
const Random = std.rand.Random;
const powMod = @import("utils.zig").powMod;

const first_primes = [_]usize{
    2,   3,   5,   7,   11,  13,  17,  19,  23,  29,  31,  37,  41,  43,
    47,  53,  59,  61,  67,  71,  73,  79,  83,  89,  97,  101, 103, 107,
    109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181,
    191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263,
    269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349,
    353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433,
    439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521,
    523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599, 601, 607, 613,
    617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691, 701,
    709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797, 809,
    811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887,
    907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997,
};

fn checkFirstPrimes(number: anytype) bool {
    for (first_primes) |prime| {
        if (number % prime == 0) {
            return false;
        }
    }
    return true;
}

fn getLowLevelPrime(random: Random, comptime T: type) T {
    var candidate = random.int(T);
    while (!checkFirstPrimes(candidate)) {
        candidate = random.int(T);
    }
    return candidate;
}

pub fn isMillerRabinPassed(
    random: Random,
    comptime T: type,
    number: T,
    accuracy: usize,
) bool {
    if (!checkFirstPrimes(number)) {
        return false;
    }
    var even_component: T = number - 1;
    var max_division_by_two: T = 0;
    while (even_component % 2 == 0) {
        even_component /= 2;
        max_division_by_two += 1;
    }
    for (0..accuracy) |_| {
        // var a = random.intRangeAtMost(T, 2, number - 1);
        var a = blk: {
            var a = random.int(T);
            while (a < 2 or a > number - 1) {
                a = random.int(T);
            }
            break :blk a;
        };
        var x = powMod(T, a, even_component, number);
        if (x == 1 or x == number - 1) {
            continue;
        }

        var i: T = 0;
        while (i < max_division_by_two) {
            x = powMod(T, x, 2, number);
            if (x == number - 1) {
                break;
            }
            i += 1;
        }
        return false;
    }
    return true;
}

pub fn getPrimeCandidate(random: Random, comptime T: type, accuracy: usize) T {
    while (true) {
        var candidate = getLowLevelPrime(random, T);
        if (!isMillerRabinPassed(random, T, candidate, accuracy)) {
            continue;
        } else {
            return candidate;
        }
    }
}

test {
    var random = std.rand.DefaultPrng.init(1);
    var rand = random.random();
    const expected = 150269890435615680026859507723321848049735320271671269071980913382807244513271045728538902280876622240790384674432102097273257564371128316697933387720011617626761112579396194019137383765017335487425990790766079480236356188286646846946504071847598106326643882492670459993843073480588306147058475997626802165279;
    const actual = getPrimeCandidate(rand, u1024, 5);
    try testing.expect(expected == actual);
}
