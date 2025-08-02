module nft:: nft {   //defines a new module named nft

    use sui::url::{Self, Url}; 
    use std::string; 
    use sui::event; 
    use sui::display;
    use sui::package;

    public struct NFT has drop {}


   
    public struct FoideNFT has key, store { 
        id: UID,
        name: string::String, 
        description: string::String, 
        url: Url,
    }


    public struct NFTMinted has copy, drop { 
        object_id: ID,
        creator: address,
        name: string::String,
    }

    fun init(witness: NFT, ctx: &mut TxContext) {
        let publisher = package::claim(witness, ctx);

        let keys = vector[
            string::utf8(b"name"),
            string::utf8(b"description"),
            string::utf8(b"image_url"),
            string::utf8(b"creator")
        ];

        let values = vector[
            string::utf8(b"{name}"),
            string::utf8(b"{description}"),
            string::utf8(b"{image_url}"),
            string::utf8(b"FoideNFT")
        ];

        let mut display = display::new_with_fields<FoideNFT>(
            &publisher, 
            keys,
            values,
            ctx
        );

        display::update_version(&mut display);

        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(display, tx_context::sender(ctx));
    }



    public entry fun mint(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let nft: FoideNFT {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(url)
        };
        let sender = tx_context::sender(ctx);
        event::emit(NFTMinted {
            object_id: object::uid_to_inner(&nft.id),
            creator: sender,
            name: nft.name,
        });
        transfer::public_transfer(nft, sender);
    }


    public entry fun update_description(
        nft: &mut FoideNFT,
        new_description: vector<u8>,
    ) {
        nft.description = string::utf8(new_description)
    }

    public entry fun burn(nft: FoideNFT) {
        let FoideNFT { id, name: _, description: _, url: _ } = nft;
        object::delete(id)
    }

    public fun name(nft: &FoideNFT): &string::String {
        &nft.name
    }

    public fun description(nft: &FoideNFT): &string::String {
        &nft.description
    }

    public fun url(nft: &FoideNFT): &Url {
        &nft.url
    }
}