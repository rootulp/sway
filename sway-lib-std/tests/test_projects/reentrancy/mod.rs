use fuel_tx::{consts::MAX_GAS_PER_TX, ContractId, Salt};
use fuels_abigen_macro::abigen;
use fuels_contract::{contract::Contract, parameters::TxParameters};
use fuels_signers::provider::Provider;
use fuels_signers::util::test_helpers::setup_test_provider_and_wallet;
use fuels_signers::wallet::Wallet;

abigen!(
    AttackerContract,
    "test_artifacts/reentrancy_attacker_contract/out/debug/reentrancy_attacker_contract-abi.json",
);

abigen!(
    TargetContract,
    "test_artifacts/reentrancy_target_contract/out/debug/reentrancy_target_contract-abi.json",
);

#[tokio::test]
async fn can_detect_reentrancy() {
    let (provider, wallet) = setup_test_provider_and_wallet().await;
    let (attacker_instance, _) = get_attacker_instance(provider.clone(), wallet.clone()).await;
    let (_, target_id) = get_target_instance(provider, wallet).await;

    let sway_target_id = attackercontract_mod::ContractId {
        value: target_id.into(),
    };

    let result = attacker_instance
        .launch_attack(sway_target_id)
        .set_contracts(&[target_id])
        .tx_params(TxParameters::new(Some(0), Some(MAX_GAS_PER_TX), None))
        .call()
        .await
        .unwrap();

    assert_eq!(result.value, true);
}

#[tokio::test]
#[should_panic(expected = "RESERV00")]
async fn can_block_reentrancy() {
    let (provider, wallet) = setup_test_provider_and_wallet().await;
    let (attacker_instance, _) = get_attacker_instance(provider.clone(), wallet.clone()).await;
    let (_, target_id) = get_target_instance(provider, wallet).await;

    let sway_target_id = attackercontract_mod::ContractId {
        value: target_id.into(),
    };

    attacker_instance
        .launch_thwarted_attack_1(sway_target_id)
        .set_contracts(&[target_id])
        .call()
        .await
        .unwrap();
}

#[tokio::test]
#[should_panic(expected = "RESERV00")]
async fn can_block_cross_function_reentrancy() {
    let (provider, wallet) = setup_test_provider_and_wallet().await;
    let (attacker_instance, _) = get_attacker_instance(provider.clone(), wallet.clone()).await;
    let (_, target_id) = get_target_instance(provider, wallet).await;

    let sway_target_id = attackercontract_mod::ContractId {
        value: target_id.into(),
    };

    attacker_instance
        .launch_thwarted_attack_2(sway_target_id)
        .set_contracts(&[target_id])
        .call()
        .await
        .unwrap();
}

#[tokio::test]
async fn can_call_guarded_function() {
    let (provider, wallet) = setup_test_provider_and_wallet().await;
    let (attacker_instance, _) = get_attacker_instance(provider.clone(), wallet.clone()).await;
    let (_, target_id) = get_target_instance(provider, wallet).await;

    let sway_target_id = attackercontract_mod::ContractId {
        value: target_id.into(),
    };

    let result = attacker_instance
        .innocent_call(sway_target_id)
        .set_contracts(&[target_id])
        .call()
        .await
        .unwrap();

    assert_eq!(result.value, true)
}

async fn get_attacker_instance(
    provider: Provider,
    wallet: Wallet,
) -> (AttackerContract, ContractId) {
    let salt = Salt::from([0u8; 32]);
    let compiled = Contract::load_sway_contract(
        "test_artifacts/reentrancy_attacker_contract/out/debug/reentrancy_attacker_contract.bin",
        salt,
    )
    .unwrap();
    let id = Contract::deploy(&compiled, &provider, &wallet, TxParameters::default())
        .await
        .unwrap();

    let instance = AttackerContract::new(id.to_string(), provider, wallet);

    (instance, id)
}

async fn get_target_instance(provider: Provider, wallet: Wallet) -> (TargetContract, ContractId) {
    let salt = Salt::from([0u8; 32]);
    let compiled = Contract::load_sway_contract(
        "test_artifacts/reentrancy_target_contract/out/debug/reentrancy_target_contract.bin",
        salt,
    )
    .unwrap();
    let id = Contract::deploy(&compiled, &provider, &wallet, TxParameters::default())
        .await
        .unwrap();

    let instance = TargetContract::new(id.to_string(), provider, wallet);

    (instance, id)
}
