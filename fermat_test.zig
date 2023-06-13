const std = @import("std");
const testing = std.testing;
const Random = std.rand.Random;
const gcd = std.math.gcd;
const utils = @import("utils.zig");
const powMod = utils.powMod;
const checkFirstPrimes = utils.checkFirstPrimes;
const getLowLevelPrime = utils.getLowLevelPrime;

pub fn isFermatTestPassed(
    random: Random,
    comptime T: type,
    number: T,
    accuracy: usize,
) bool {
    if (number == 1 or number == 4) return false;
    if (number == 2 or number == 3) return true;
    for (0..accuracy) |_| {
        var rand = random.int(T) - 111;
        var a = powMod(T, rand, number - 1, number);
        if (gcd(a, number) == 1 and a != 1) {
            return false;
        }
    }
    return true;
}

pub fn getPrimeCandidate(random: Random, comptime T: type, accuracy: usize) T {
    while (true) {
        var candidate = getLowLevelPrime(random, T);
        if (!isFermatTestPassed(random, T, candidate, accuracy)) {
            continue;
        } else {
            return candidate;
        }
    }
}

test {
    var random = std.rand.DefaultPrng.init(1);
    var rand = random.random();
    try testing.expectEqual(false, isFermatTestPassed(rand, u32, 1024, 100));
    try testing.expectEqual(true, isFermatTestPassed(rand, u32, 1229, 100));
    try testing.expectEqual(true, isFermatTestPassed(rand, u32, 2147483647, 100));
    // Carmichael Number 5*13*17
    try testing.expectEqual(true, isFermatTestPassed(rand, u16, 1105, 1));

    try testing.expect(2917007507 == getPrimeCandidate(rand, u32, 100));
}
