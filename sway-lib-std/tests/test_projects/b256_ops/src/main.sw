script;

use std::assert::assert;
use std::b256_ops::*;


fn main() -> bool {
    let one = 1;
    let two = 2;
    let three = 3;
    let four = 4;

    let test_val: b256 = 0x0000000000000001_0000000000000002_0000000000000003_0000000000000004;

    let composed = compose_b256_from_words(one, two, three, four);
    assert(composed == test_val);

    let (w1, w2, w3, w4) = decompose_b256_to_words(test_val);
    assert(w1 == one);
    assert(w2 == two);
    assert(w3 == three);
    assert(w4 == four);

    let a =  0x1000000000000001_1000000000000001_1000000000000001_1000000000000001;
    let b =  0x0000000100000001_0000000010000001_0000000010000001_0000000010000001;
    let c =  0x0000000000000001_0000000000000001_0000000000000001_0000000000000001;
    assert(a.and_b256(b) == c);

    true
}
