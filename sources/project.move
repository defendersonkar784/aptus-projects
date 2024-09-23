module MyModule::SocialMediaRewards {

    use aptos_framework::coin;
    use aptos_framework::signer;
    use aptos_framework::aptos_coin::{AptosCoin};

    struct Reward has store, key {
        creator: address,
        engager: address,
        content_id: u64,
        reward_amount: u64,
        is_rewarded: bool,
    }

    // Function to reward content creators
    public fun reward_creator(account: &signer,content_id: u64, reward_amount: u64) {
        let creator = signer::address_of(account);
        let reward = Reward {
            creator,
            engager: signer::address_of(account),
            content_id,
            reward_amount,
            is_rewarded: false,
        };
        move_to(creator, reward);
    }

    // Function to reward users for engaging with content
    public fun reward_engager(content_id: u64, reward_amount: u64) acquires Reward {
        let engager = signer::address_of(signer::borrow_current_signer());
        let reward = borrow_global_mut<Reward>(engager);

        // Ensure the reward is not already given
        assert!(!reward.is_rewarded, 1);

        // Transfer tokens to the engager
        coin::transfer<AptosCoin>(&signer::borrow_current_signer(), engager, reward_amount);

        // Mark reward as given
        reward.is_rewarded = true;
    }

    // Helper function to get the current timestamp (Placeholder)
    fun timestamp(): u64 {
        // Implement a method to get the current timestamp; placeholder for example
        0
    }
}
