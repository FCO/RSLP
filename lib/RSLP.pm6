unit class RSLP is Routine;
use RSLP::Step;

method new {::?CLASS.bless}

my &plural = RSLP::Step.new: :name<plural> :suffixes["s"];
&plural.add-rule: :suffix<ns>    :1min-size :add-suffix<m>;
&plural.add-rule: :suffix<ões>   :3min-size :add-suffix<ão>;
&plural.add-rule: :suffix<ais>   :1min-size :add-suffix<al> :exceptions<cais mais>;
&plural.add-rule: :suffix<éis>   :2min-size :add-suffix<el>;
&plural.add-rule: :suffix<eis>   :2min-size :add-suffix<el>;
&plural.add-rule: :suffix<óis>   :2min-size :add-suffix<ol>;
&plural.add-rule: :suffix<is>   :2min-size :add-suffix<il> :exceptions<
    lápis cais mais crúcis biquínis pois depois dois leis
    >;
&plural.add-rule: :suffix<les>   :3min-size :add-suffix<l>;
&plural.add-rule: :suffix<res>   :3min-size :add-suffix<r>;
&plural.add-rule: :suffix<ães>   :1min-size :add-suffix<ão> :exceptions<mães>;
&plural.add-rule: :suffix<s>     :2min-size :add-suffix("") :exceptions<
    aliás   pires   lápis   cais    mais
	férias  fezes   pêsames crúcis  gás
	atrás   moisés  através convés  ês
	país    após    ambas   ambos   messias
	mas     menos
>;

my &adverb = RSLP::Step.new: :name<adverb>;
&adverb.add-rule: :suffix<mente> :4min-size :exceptions<
    clemente documente experimente inclemente sedimente veemente
>;

sub remove-marks($_) { .samemark("a") }

my %steps =
	__INITIAL__	=> &plural,
	plural		=> &adverb,
    adverb		=> &remove-marks,
;

method CALL-ME($word) {
	my $stem	= $word;
	my $step	= %steps<__INITIAL__>;
	while $step.defined {
		$stem	= $step($stem);
		$step	= %steps{$step.?name};
        $step   = $step{?$stem} if $step ~~ Hash
	}
	$stem
}
