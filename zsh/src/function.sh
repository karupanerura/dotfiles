function perlv {
    perl -M$1 -E "say \$$1::VERSION"
}
