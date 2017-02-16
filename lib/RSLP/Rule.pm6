unit class RSLP::Rule is Routine;

has Str         $.suffix;
has Int         $.min-size		is default(0);
has Str         $.add-suffix;
has Junction    $.exception     = any();

method new(::?CLASS:U: *%params) {
	%params<exception> = any %params<exceptions>
        if %params<exceptions>:exists;
	self.bless: |%params
}
multi method CALL-ME(Str:D $word) {$word ~ "" but False}
multi method CALL-ME(
	Str:D $word where {
			.chars >= $!min-size
		and .ends-with($!suffix)
		and not $_ eq $!exception
	}
) {
	my ($remove, $add) = $!suffix, $!add-suffix;
	S/$remove $/$add/ but True given $word
}
