#include <bits/stdc++.h>

extern "C" void _print(char* buf, const char* format, const char* hex_number);

int main() {
	std::string num;
	num = "00000000000000000000000000000005";
	char ans[30];
	for (int i = 0; i < 30; i++) {
		ans[i] = 0;
	}
	_print(ans, "%+010i", num.c_str());
	int i = 0;
	while (ans[i] != 0) {
		std::cout << ans[i];
		i++;
	}
	std::cout << "\n";
	for (int i = 0; i < 20; i++) {
		std::cout << int(ans[i]) << " ";
	}
	std::cout << "\n";
	return 0;
}