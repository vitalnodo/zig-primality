const std = @import("std");
const testing = std.testing;
const Random = std.rand.Random;
const utils = @import("utils.zig");
const checkFirstPrimes = utils.checkFirstPrimes;
const getLowLevelPrime = utils.getLowLevelPrime;
const intRangeAtMost = utils.intRangeAtMost;

fn calcMillerRabinAccuracy(comptime T: type) usize {
    if (@typeInfo(T).Int.bits <= 2048) {
        return 64;
    } else {
        return 128;
    }
}

pub fn isMillerRabinPassed(
    random: Random,
    number: anytype,
) !bool {
    const T = @TypeOf(number);
    const bits = @typeInfo(T).Int.bits;
    const M = std.crypto.ff.Modulus(bits);
    const I = std.crypto.ff.Uint(bits);
    const m_ = try M.fromPrimitive(T, number);

    var even_component: T = number - 1;
    const number_minus_one_ = m_.reduce(try I.fromPrimitive(
        T,
        even_component,
    ));
    var max_division_by_two: usize = 0;
    while (even_component & 1 == 0) {
        even_component >>= 1;
        max_division_by_two += 1;
    }
    const even_component_ = m_.reduce(
        try I.fromPrimitive(T, even_component),
    );
    const two_ = &[1]u8{2};
    const accuracy = comptime calcMillerRabinAccuracy(T);
    for (0..accuracy) |_| {
        var a_ = m_.reduce(
            try I.fromPrimitive(
                T,
                intRangeAtMost(random, T, 2, number - 1),
            ),
        );
        var x_ = try m_.pow(a_, even_component_);
        if (x_.eql(m_.one()) or x_.eql(number_minus_one_)) {
            continue;
        }

        var i: usize = 0;
        while (i < max_division_by_two) {
            x_ = try m_.powWithEncodedExponent(x_, two_, .Big);
            if (x_.eql(number_minus_one_)) {
                break;
            }
            i += 1;
        }
        return false;
    }
    return true;
}

pub fn getPrimeCandidate(random: Random, comptime T: type) !T {
    while (true) {
        var candidate = getLowLevelPrime(random, T);
        const passed = try isMillerRabinPassed(
            random,
            candidate,
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
    const expected = 27313240486808431272031427228077286115999947134248264955977532294773023934131383248957721508427481353771679509690618774398177736134786063971294459720426292247440925178719201299523358382182981277942567852631255378566506614053452474861913867183764193237557652997063641917666378394169723205398147258420492100571;
    const actual = try getPrimeCandidate(rand, u1024);
    try testing.expect(expected == actual);
}
