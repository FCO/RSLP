unit class RSLP is Routine;
use RSLP::Step;

method new {::?CLASS.bless}

my RSLP::Step $step1 .= new: :name<plural> :suffixes["s"];
$step1.add-rule: :suffix<ns>    :1min-size :add-suffix<m>;
$step1.add-rule: :suffix<ões>   :3min-size :add-suffix<ão>;
$step1.add-rule: :suffix<ais>   :1min-size :add-suffix<al> :exceptions<cais mais>;
$step1.add-rule: :suffix<éis>   :2min-size :add-suffix<el>;
$step1.add-rule: :suffix<eis>   :2min-size :add-suffix<el>;
$step1.add-rule: :suffix<óis>   :2min-size :add-suffix<ol>;
$step1.add-rule: :suffix<is>   :2min-size :add-suffix<il> :exceptions<
    lápis cais mais crúcis biquínis pois depois dois leis
    >;
$step1.add-rule: :suffix<les>   :3min-size :add-suffix<l>;
$step1.add-rule: :suffix<res>   :3min-size :add-suffix<r>;
$step1.add-rule: :suffix<ães>   :1min-size :add-suffix<ão> :exceptions<mães>;
$step1.add-rule: :suffix<s>     :2min-size :add-suffix("") :exceptions<
    aliás   pires   lápis   cais    mais
	férias  fezes   pêsames crúcis  gás
	atrás   moisés  através convés  ês
	país    após    ambas   ambos   messias
	mas     menos
>;

sub remove-marks($_) { .samemark("a") }

my %steps =
	__INITIAL__	=> $step1,
	plural		=> {
		True	=> &remove-marks,
		False	=> &remove-marks,
	},
;

method CALL-ME($word) {
	my $stem	= $word;
	my $step	= %steps<__INITIAL__>;
	while $step.defined {
		$stem	= $step($stem);
		$step	= %steps{$step.?name}{?$stem}
	}
	$stem
}
