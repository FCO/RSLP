unit class RSLP is Routine;
use RSLP::Step;

my %cache;
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

my &feminine = RSLP::Step.new: :name<feminine> :suffixes<a ã>;
&feminine.add-rule: :suffix<ona> :3min-size :add-suffix<ão> :exceptions<
    abandona lona iona cortisona monótona maratona acetona detona carona
>;
&feminine.add-rule: :suffix<ora> :3min-size :add-suffix<or>;
&feminine.add-rule: :suffix<na> :4min-size :add-suffix<no> :exceptions<
    carona      abandona    lona        iona
    cortisona   monótona    maratona    acetona
    detona      guiana      campana     grana
    caravana    banana      paisana
>;
&feminine.add-rule: :suffix<inha> :3min-size :add-suffix<inho> :exceptions<
    daninha farinha rainha linha minha
>;
&feminine.add-rule: :suffix<esa> :3min-size :add-suffix<ês> :exceptions<
    mesa obesa princesa turquesa ilesa pesa presa
>;
&feminine.add-rule: :suffix<osa> :3min-size :add-suffix<oso> :exceptions<
    mucosa prosa
>;
&feminine.add-rule: :suffix<íaca> :3min-size :add-suffix<íaco>;
&feminine.add-rule: :suffix<ica> :3min-size :add-suffix<ico> :exceptions<
    dica
>;
&feminine.add-rule: :suffix<ada> :2min-size :add-suffix<ado> :exceptions<
    pitada
>;
&feminine.add-rule: :suffix<ida> :3min-size :add-suffix<ido> :exceptions<
    vida
>;
&feminine.add-rule: :suffix<ída> :3min-size :add-suffix<ido> :exceptions<
    recaída saída dúvida
>;
&feminine.add-rule: :suffix<ima> :3min-size :add-suffix<imo> :exceptions<
    vítima
>;
&feminine.add-rule: :suffix<iva> :3min-size :add-suffix<ivo> :exceptions<
    saliva oliva
>;
&feminine.add-rule: :suffix<eira> :3min-size :add-suffix<eiro> :exceptions<
    beira       cadeira     frigideira  bandeira
    feira       capoeira    barreira    fronteira
    besteira    poeira
>;
&feminine.add-rule: :suffix<ã> :2min-size :add-suffix<ão> :exceptions<
    amanhã arapuã fã divã
>;

sub remove-marks($_) { .samemark("a") }

my %steps =
	__INITIAL__	=> &plural,
	plural		=> &adverb,
    adverb		=> &feminine,
    feminine	=> &remove-marks,
;

method CALL-ME($word) {
    .return with %cache{$word};
	my $stem	= $word;
	my $step	= %steps<__INITIAL__>;
	while $step.defined {
		$stem	= $step($stem);
		$step	= %steps{$step.?name};
        $step   = $step{?$stem} if $step ~~ Hash;
        $stem ~= ""
	}
	%cache{$word} = $stem
}
