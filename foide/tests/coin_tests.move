#[test_only] // This module is only compiled for tests
module coin::foide_tests; // Define the test module for foide

use coin::foide::{Self, foide}; // Import the foide module and foide struct
use sui::coin::{TreasuryCap}; // Import TreasuryCap from sui::coin
use sui::test_scenario::{Self, next_tx, ctx}; // Import test scenario utilities

#[test] // Mark this function as a test
fun init_and_mint() { // Test function to initialize and mint foide coins
    let addr1 = @0xA; // Mock sender address

    let mut scenario = test_scenario::begin(addr1); // Start a new test scenario with addr1

  
    next_tx(&mut scenario, addr1); // Advance to the next transaction in the scenario
    {
        let mut treasurycap = test_scenario::take_from_sender<TreasuryCap<foide>>(&scenario); // Retrieve TreasuryCap<foide> from sender
        foide::mint(&mut treasurycap, 1000000_00000000, addr1, ctx(&mut scenario)); // Mint 1,000,000 foide (with 8 decimals) to addr1

        test_scenario::return_to_address<TreasuryCap<foide>>(addr1, treasurycap); // Return TreasuryCap to sender
    };

    test_scenario::end(scenario); // End and clean up the scenario
}
