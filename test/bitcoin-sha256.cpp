#include <iostream>

#include "primitives/block.h"

#include "hash.h"
#include "tinyformat.h"
#include "utilstrencodings.h"
#include "crypto/common.h"
#include "sph_keccak.h"
#include "streams.h"

int
main(int argc, char const *argv[])
{
    CBlockHeader block;
    sph_keccak256_context ctx_keccak;
    CDataStream ss(SER_GETHASH, PROTOCOL_VERSION);
    ss << block.GetHash();
    uint256 hash;
    sph_keccak256_init(&ctx_keccak);
    sph_keccak256(&ctx_keccak, (void*)&*ss.begin(), ss.size());
    sph_keccak256_close(&ctx_keccak, static_cast<void*>(&hash));
    //std::cout << block.hashMerkleRoot.ToString() << "\n";
    std::cout << hash.ToString() << "\n";
    std::cout << block.GetHash().ToString() << "\n";
    return EXIT_SUCCESS;
}
