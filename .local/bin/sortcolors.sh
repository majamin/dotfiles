#!/bin/bash

# Reads colors as hex values from
# stdin and sorts them according
# to HSL values, outputting the
# result

hex_values=()

# Define awk script for converting hex to HSL values
awk_script='
function max2(a,b) {
    return (a > b ? a : b)
}

function min2(a,b) {
    return (a < b ? a : b)
}

function hex_to_hsl(hex) {
    r = strtonum("0x" substr(hex, 1, 2));
    g = strtonum("0x" substr(hex, 3, 2));
    b = strtonum("0x" substr(hex, 5, 2));
    r /= 255; g /= 255; b /= 255;
    maxval = max2(max2(r, g), b);
    minval = min2(min2(r, g), b);
    h = (maxval + minval) / 2;
    s = h;
    l = h;
    if (maxval == minval) {
        h = 0;
        s = 0;
    } else {
        d = maxval - minval;
        s = l > 0.5 ? d / (2 - maxval - minval) : d / (maxval + minval);
        if (maxval == r) {
            h = (g - b) / d + (g < b ? 6 : 0);
        } else if (maxval == g) {
            h = (b - r) / d + 2;
        } else if (maxval == b) {
            h = (r - g) / d + 4;
        }
        h /= 6;
    }
    return sprintf("%1.f %1.f %1.f", h * 360, s * 100, l * 100);
}

BEGIN {
    # Set input field separator to comma
    FS = ","
}
{
    # Convert hex values to HSL and store in array
    colors[$1] = hex_to_hsl($1);
}

END {
    # Sort colors by hue, saturation, and lightness
    n = asorti(colors, sorted_hex_values, "@val_num_asc");
    printf("HEX; HSL")
    for (i = 1; i <= n; i++) {
        hex_value = sorted_hex_values[i];
        hsl_value = colors[hex_value];
        printf("#%s; %s\n", substr(hex_value,1), hsl_value);
    }
}'

# Read hex color values from standard input
while read -r value; do
    # Convert hex color value to HSL
    hex_values+=("$(echo $value | tr -d '#')")
done

# Sort colors using the awk script
sorted=$(printf "%s\n" "${hex_values[@]}" | awk -F ',' "$awk_script")

# Print sorted colors
echo "${sorted}"
