const std = @import("std");
const testing = std.testing;
const Random = std.rand.Random;
const powMod = @import("utils.zig").powMod;
const checkFirstPrimes = @import("utils.zig").checkFirstPrimes;

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
