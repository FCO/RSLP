unit class RSLP::Step is Routine;
use RSLP::Rule;

has Str         $.name		is required;
has Int         $.min-size	is default(0);
has Bool        $.full-word-compare		= False;
has Junction    $.suffix;
has RSLP::Rule  @.rules		handles "push";

method new(::?CLASS:U: *%params) {
	%params<suffix> = any %params<suffixes>;
	%params<min-size> = %params<rules>.map({.min-size}).min
		if %params<rules>:exists and not %params<min-size>:exists;
	self.bless: |%params
}
method add-rule(::?CLASS::D: *%params) {
	$.push(RSLP::Rule.new: |%params);
	$!min-size min= %params<min-size>
}
multi method CALL-ME(Str:D $word) {$word ~ "" but False}
multi method CALL-ME(
	Str:D $word where {
			.chars >= $!min-size
		and $!full-word-compare
		?? $_ eq $!suffix
		!! .ends-with($!suffix)
	}
) {
	my $stem = $word;
	for @!rules -> &rule {
		$stem = rule($stem);
		last if $stem
	}
	$stem ~ "" but True
}
