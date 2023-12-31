const std = @import("std");
const testing = std.testing;
const Random = std.rand.Random;
const gcd = std.math.gcd;
const utils = @import("utils.zig");
const checkFirstPrimes = utils.checkFirstPrimes;
const getLowLevelPrime = utils.getLowLevelPrime;
const intRangeAtMost = utils.intRangeAtMost;

pub fn isFermatTestPassed(
    random: Random,
    number: anytype,
    accuracy: usize,
) !bool {
    const T = @TypeOf(number);
    const bits = @typeInfo(T).Int.bits;
    const M = std.crypto.ff.Modulus(bits);
    const I = std.crypto.ff.Uint(bits);
    const m_ = try M.fromUint(try I.fromPrimitive(T, number));
    const number_minus_one_ = m_.reduce(
        try I.fromPrimitive(T, number - 1),
    );
    for (0..accuracy) |_| {
        var rand = intRangeAtMost(random, T, 2, number - 1);
        var rand_ = m_.reduce(try I.fromPrimitive(T, rand));
        var a_ = try m_.pow(rand_, number_minus_one_);
        if (!a_.eql(m_.one())) {
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
    try testing.expectEqual(true, try isFermatTestPassed(
        rand,
        @as(u32, @intCast(1229)),
        100,
    ));
    try testing.expectEqual(true, try isFermatTestPassed(
        rand,
        @as(u32, @intCast(2147483647)),
        100,
    ));
    // Carmichael Number 5*13*17
    try testing.expectEqual(true, try isFermatTestPassed(
        rand,
        @as(u32, @intCast(1105)),
        1,
    ));

    try testing.expect(2917007507 == try getPrimeCandidate(
        rand,
        u32,
        100,
    ));
}
