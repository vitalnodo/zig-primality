const std = @import("std");
const testing = std.testing;
const Random = std.rand.Random;
const utils = @import("utils.zig");
const powMod = utils.powMod;
const checkFirstPrimes = utils.checkFirstPrimes;
const getLowLevelPrime = utils.getLowLevelPrime;

pub fn isMillerRabinPassed(
    random: Random,
    comptime T: type,
    number: T,
    accuracy: usize,
) bool {
    var even_component: T = number - 1;
    var max_division_by_two: T = 0;
    while (even_component % 2 == 0) {
        even_component /= 2;
        max_division_by_two += 1;
    }
    for (0..accuracy) |_| {
        // var a = random.intRangeAtMost(T, 2, number - 1);
        var a = random.int(T) - 111;
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
    const expected = 27313240486808431272031427228077286115999947134248264955977532294773023934131383248957721508427481353771679509690618774398177736134786063971294459720426292247440925178719201299523358382182981277942567852631255378566506614053452474861913867183764193237557652997063641917666378394169723205398147258420492100571;
    const actual = getPrimeCandidate(rand, u1024, 5);
    try testing.expect(expected == actual);
}
