const std = @import("std");
const testing = std.testing;

pub fn powMod(comptime T: type, a: T, b: T, m: T) T {
    const doubled = std.meta.Int(
        std.builtin.Signedness.unsigned,
        @bitSizeOf(T) * 2,
    );
    var r: doubled = 1;
    var x: doubled = a % m;
    var y = b;

    while (y > 0) {
        var d = y % 2;
        if (d == 1) {
            r = (r * x) % m;
        }
        x = (x * x) % m;
        y = y / 2;
    }

    return @intCast(T, r);
}

test {
    const tests_pow = [_][4]u64{
        [4]u64{ 11378123410748079934, 16421262333679916698, 5588982832880222953, 193029793147236230 },
        [4]u64{ 14834571546141995710, 4369117763020698127, 7135917169530990590, 2231096743281764010 },
    };
    for (tests_pow) |test_pow| {
        const x = test_pow[0];
        const y = test_pow[1];
        const m = test_pow[2];
        const r = test_pow[3];
        const actual = powMod(u64, x, y, m);
        try testing.expectEqual(r, @intCast(u64, actual));
    }
}

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

pub fn checkFirstPrimes(number: anytype) bool {
    for (first_primes) |prime| {
        if (number % prime == 0) {
            return false;
        }
    }
    return true;
}
