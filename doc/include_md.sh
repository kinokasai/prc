 awk '
$1=="\\include" && NF>=2 {
   system("./include_md.sh "$2)
   next
}
{print}' "$@"
