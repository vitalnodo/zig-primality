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
