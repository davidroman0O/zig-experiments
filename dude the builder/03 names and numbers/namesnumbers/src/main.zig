const std = @import("std");

const global_const: u8 = 42;
var global_var: u8 = 0;

fn printInfo(name: []const u8, x: anytype) void {
    // be super careful with those fmt strings, i had an error because i forgot a `}`
    // error: expected . or }, found '	'
    // @compileError("expected . or }, found '" ++ [1]u8{ch} ++ "'");
    std.debug.print("{s:>10} {any:^10} \t{}\n", .{ name, x, @TypeOf(x) });
}

pub fn main() !void {
    printInfo("global_const", global_const);
    const inference_constant = 1;
    printInfo("inference", inference_constant);
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    var a_var: u8 = 2;
    a_var += 1;
    printInfo("simple are", a_var);

    // const b; // must be initialized
    var undefinedvar: u8 = undefined;
    // can be anything, my terminal says 170, it will print a garbage value
    // it's kind of a weird behavior to me, i'm used to have at least 0
    printInfo("undefined", undefinedvar);
    undefinedvar = 2;
    printInfo("undefined", undefinedvar);

    var defaultone: u8 = 0; // better to set myself a default
    _ = defaultone; // if i don't want to use the variable, just like in golang

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // don't forget to flush!
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
