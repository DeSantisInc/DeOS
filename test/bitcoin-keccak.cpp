#include <iostream>
#include "sph_keccak.h"

int
main(int argc, char const *argv[])
{   // CDataStream ss(SER_GETHASH, PROTOCOL_VERSION);
    // ss << *this;
    // uint256 hash;
    sph_keccak256_context ctx_keccak;
    sph_keccak256_init(&ctx_keccak);
    // sph_keccak256(&ctx_keccak, (void*)&*ss.begin(), ss.size());
    // sph_keccak256_close(&ctx_keccak, static_cast<void*>(&hash));
    std::cout << "keccak\n";
    return EXIT_SUCCESS;
}
