script;

use std::assert::assert;
use std::b256_ops::*;

fn main() -> bool {

    // let val_0 = 0x0000000000000000000000000000000000000000000000000000000000000000;
    let val_1 = 0x0000000000000000000000000000000000000000000000000000000000000001;

    // assert(val_1.b256_and(val_0) == val_0);
    assert(val_1.and_b256(val_1) == val_1);
    true
}
