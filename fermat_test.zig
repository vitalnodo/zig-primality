const std = @import("std");
const testing = std.testing;
const Random = std.rand.Random;
const gcd = std.math.gcd;
const utils = @import("utils.zig");
const powModOdd = utils.powModOdd;
const checkFirstPrimes = utils.checkFirstPrimes;
const getLowLevelPrime = utils.getLowLevelPrime;
const intRangeAtMost = utils.intRangeAtMost;

pub fn isFermatTestPassed(
    random: Random,
    comptime T: type,
    number: T,
    accuracy: usize,
) !bool {
    if (number == 1 or number == 4) return false;
    if (number == 2 or number == 3) return true;
    for (0..accuracy) |_| {
        var rand = intRangeAtMost(random, T, 2, number - 1);
        var a = powModOdd(rand, number - 1, number) catch |err| switch (err) {
            error.EvenModulus => continue,
            else => unreachable,
        };
        if (gcd(a, number) == 1 and a != 1) {
            return false;
        }
    }
    return true;
}

pub fn getPrimeCandidate(random: Random, comptime T: type, accuracy: usize) !T {
    while (true) {
        var candidate = getLowLevelPrime(random, T);
        const passed = try isFermatTestPassed(
            random,
            T,
            candidate,
            accuracy,
        );
        if (passed) {
            return candidate;
        } else {
            continue;
        }
    }
}

test {
    var random = std.rand.DefaultPrng.init(1);
    var rand = random.random();
    // try testing.expectEqual(true, try isFermatTestPassed(rand, u32, 1024, 100));
    try testing.expectEqual(true, try isFermatTestPassed(rand, u32, 1229, 100));
    try testing.expectEqual(true, try isFermatTestPassed(rand, u32, 2147483647, 100));
    // Carmichael Number 5*13*17
    try testing.expectEqual(true, try isFermatTestPassed(rand, u16, 1105, 1));

    try testing.expect(2917007507 == try getPrimeCandidate(rand, u32, 100));
}
