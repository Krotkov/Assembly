#include <bits/stdc++.h>

extern "C" void fdct(const float* in, float* out);

int main() {
	freopen("/home/kranya/Assembly/dct/input.txt", "r", stdin);
    float in[256];
    float out[256];
    for (size_t i = 0; i < 256; ++i) {
        char c;
        std::cin >> in[i];
        std::cin >> c;
    }
	fdct(in, out);
	for (size_t i = 0; i < 16; i++) {
		for (size_t j = 0; j < 16; j++) {
			std::cout << out[i*16+j] << " ";
		}
		std::cout << "\n";
	}
	std::cout << "hello world!" << std::endl;
	return 0;
}