#include <stdio.h>

int main() {
## void
## max_unique_n_substr(char *in_str, char *out_str, int n) {
##     if (!in_str || !out_str || !n)
##         return;
## 
##     char *max_marker = in_str;
##     unsigned int len_max = 0;
##     unsigned int len_in_str = my_strlen(in_str);
##     for (unsigned int cur_pos = 0; cur_pos < len_in_str; cur_pos++) {
##         char *i = in_str + cur_pos;
##         int len_cur = n_uniq_char(i, n + 1);
##         if (len_cur > len_max) {
##             len_max = len_cur;
##             max_marker = i;
##         }
##     }
## 
##     my_strncpy(out_str, max_marker, len_max);
## }
);

	return 0;
}
