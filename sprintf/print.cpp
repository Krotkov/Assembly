#include <bits/stdc++.h>

extern "C" void _print(char* buf, const char* format, const char* hex_number);

int main() {
	std::string num;
	num = "10";
	char ans[40];
	for (int i = 0; i < 30; i++) {
		ans[i] = 0;
	}
	_print(ans, "+-05", num.data());
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