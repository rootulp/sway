script;

use std::assert::assert;
use std::b256_ops::*;
use std::chain::log_u64;


fn main() -> bool {
    let one = 1;
    let two = 2;
    let three = 3;
    let four = 4;

    let test_val: b256 = 0x0000000000000001_0000000000000002_0000000000000003_0000000000000004;

    let composed = compose(one, two, three, four);
    assert(composed == test_val);

    let (w1, w2, w3, w4) = decompose(test_val);
    assert(w1 == one);
    assert(w2 == two);
    assert(w3 == three);
    assert(w4 == four);


    let a =  0x1000000000000001_1000000000000001_1000000000000001_1000000000000001;
    let b =  0x0000000100000001_0000000010000001_0000000010000001_0000000010000001;
    let c =  0x0000000000000001_0000000000000001_0000000000000001_0000000000000001;
    let d =  0x1000000100000001_1000000010000001_1000000010000001_1000000010000001;
    let e =  0x1000000100000000_1000000010000000_1000000010000000_1000000010000000;

    // test and_b256()
    assert(a.and_b256(b) == c);
    // test or_b256()
    assert(a.or_b256(b) == d);
    // test xor_b256()
    assert(a.xor_b256(b) == e);

    let (shifted, overflow) = shift_left_and_preserve_overflow(1, 1);
    // log_u64(shifted);
    // log_u64(overflow);
    assert(shifted == 2);
    assert(overflow == 0);

    let max_u64 = 18_446_744_073_709_551_615;
    // log_u64(max_u64);

    let (shifted_2, overflow_2) = shift_left_and_preserve_overflow(max_u64, 1);
    // log_u64(shifted_2);
    // log_u64(overflow_2);
    // assert(shifted_2 == max_u64 - 1);
    // assert(overflow_2 == 1);

    let (shifted_3, overflow_3) = shift_left_and_preserve_overflow(1, 63);
    log_u64(shifted_3);
    log_u64(overflow_3);
    assert(shifted_3 == 9223372036854775808); // (1*2^63)
    // assert(overflow_3 == 3);

    let (shifted_4, overflow_4) = shift_left_and_preserve_overflow(1, 64);
    log_u64(shifted_4); // 1 !?
    log_u64(overflow_4);
    // assert(shifted_3 == 0); // (1*2^63)

    let (shifted_5, overflow_5) = shift_left_and_preserve_overflow(9223372036854775808, 1);
    log_u64(shifted_4); // 1 !?
    log_u64(overflow_4);

    // log_u64(max_u64);

    // let (max_shifted, max_overflow) = shift_left_and_preserve_overflow(max_u64, 63);
    // log_u64(max_shifted);
    // log_u64(max_overflow);
    // assert(shifted_2 == max_u64 - 1);
    // assert(overflow_2 == 1);

    true
}

/**
18446744073709551615
 9223372036854775808

 If the F_WRAPPING flag is unset, an operation that would have set $of to a non-zero value is instead a panic.

 If the F_WRAPPING flag is set, an operation can set $of to a non-zero value instead of panicking

*/